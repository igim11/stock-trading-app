class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :first_name, :last_name, :user_id, presence: true

  has_many :transactions
  
  # validates :status, inclusion: { in: %w[pending approved], message: "%{value} is not a valid status" }

  before_validation :set_default_status, on: :create
  after_create :notify_admin

  before_save :set_status_based_on_approval

  # Method to calculate stocks owned by the user and their value
  def portfolio_value
    client = IEX::Api::Client.new(
      publishable_token: 'pk_28432911a33d4e58a546ae4a261bd3dc',
      secret_token: 'sk_91c66919e98d4d5093a8872d5077f931',
      endpoint: 'https://cloud.iexapis.com/v1'
    )

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
