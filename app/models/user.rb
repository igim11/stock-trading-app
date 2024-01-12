class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # validates :first_name, :last_name, :user_id, presence: true

  has_many :transactions
  
  # validates :status, inclusion: { in: %w[pending approved], message: "%{value} is not a valid status" }

  # before_validation :set_default_status, on: :create
  # after_create :notify_admin

  # before_save :set_status_based_on_approval

  def portfolio_value
    client = IEX::Api::Client.new

    portfolio = {}
    transactions.each do |transaction|
      stock = transaction.stock
      shares = transaction.shares
      price = client.price(stock)
      if transaction.action == 'buy'
        if portfolio[stock]
          portfolio[stock][:shares] += shares
          portfolio[stock][:value] += shares * price
        else
          portfolio[stock] = { shares: shares, value: shares * price }
        end
      elsif transaction.action == 'sell'
        if portfolio[stock]
          portfolio[stock][:shares] -= shares
          portfolio[stock][:value] -= shares * price
        else
          portfolio[stock] = { shares: -shares, value: -shares * price }
        end
      end
    end
    portfolio
  end

  def all_transactions
  transactions.order(created_at: :desc).map do |transaction|
    {
      stock: transaction.stock,
      shares: transaction.shares,
      action: transaction.action,
      amount: transaction.amount,
      created_at: transaction.created_at
    }
  end
end

  def owns_stock?(stock)
    transactions.where(stock: stock).exists?
  end

  private

  def set_default_status
    self.status = 'Pending' if status.blank?
  end

  def set_status_based_on_approval
    self.status = 'Approved' if status_change_to_be_approved?
  end

  def status_change_to_be_approved?
    status_changed? && status == 'Approved'
  end

end
