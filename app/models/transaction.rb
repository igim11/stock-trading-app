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
end
