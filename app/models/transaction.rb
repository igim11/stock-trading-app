class Transaction < ApplicationRecord
  belongs_to :user

  validates :stock, :shares, :user_id, :action, presence: true

  # Scope for buy transactions
  scope :buys, -> { where(action: 'buy') }

  # Scope for sell transactions
  scope :sells, -> { where(action: 'sell') }

  # Scope for transactions by user
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  before_validation :validate_stock_code_exists

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
    if stock.present? && action == 'buy' && shares.present?
      stock_price = IEX::Api::Client.new.quote(stock).latest_price
      if (shares * stock_price) > user.cash
        errors.add(:amount, "cannot be more than available balance")
      end
    end
  end

  def check_amount_against_stock
    if stock.present? && shares.present? && action == 'sell' && shares > user.transactions.where(stock: stock).sum(:shares)
      errors.add(:amount, "cannot be more than what you own")
    end
  end
end
