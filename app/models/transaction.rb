class Transaction < ApplicationRecord
  belongs_to :user

  # Scope for buy transactions
  scope :buys, -> { where(action: 'buy') }

  # Scope for sell transactions
  scope :sells, -> { where(action: 'sell') }

  # Scope for transactions by user
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  validates :stock, presence: true
  validates :amount, presence: true
  validates :user_id, presence: true
  validates :action, presence: true
  validate :validate_stock_code_exists
  validate :check_amount_against_cash, on: :create
  validate :check_amount_against_stock, on: :create

  private

  def validate_stock_code_exists
    if stock.present?
      begin
        data = IEX::Api::Client.new.quote(stock)
      rescue IEX::Errors::SymbolNotFoundError
        errors.add(:stock, "does not exist")
      end
    end
  end

  def check_amount_against_cash
    if stock.present? && action == 'buy' && amount > user.cash  # Assuming 'action' and 'user' are associated fields
      errors.add(:amount, "cannot be more than available balance")
    end
  end

  def check_amount_against_stock
    if stock.present? && action == 'sell' && amount > user.transactions.where(stock: stock).sum(:shares) * IEX::Api::Client.new.quote(stock).latest_price
      errors.add(:amount, "cannot be more than what you own")
    end
  end
end
