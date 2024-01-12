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

   # Method to calculate stocks owned by the user
   def owned_stocks
    # Get all buy transactions for the user
    buy_transactions = transactions.buys.group(:stock).sum(:shares)

    # Get all sell transactions for the user
    sell_transactions = transactions.sells.group(:stock).sum(:shares)

    # Subtract sold stocks from bought stocks
    buy_transactions.each do |stock, shares|
      buy_transactions[stock] -= sell_transactions[stock].to_i
    end

    # Filter out any stocks that have been sold out
    buy_transactions.select { |_, shares| shares > 0 }
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
