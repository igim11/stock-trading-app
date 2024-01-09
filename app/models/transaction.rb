class Transaction < ApplicationRecord
  belongs_to :user

  # Scope for buy transactions
  scope :buys, -> { where(action: 'buy') }

  # Scope for sell transactions
  scope :sells, -> { where(action: 'sell') }

  # Scope for transactions by user
  scope :by_user, ->(user_id) { where(user_id: user_id) }
end
