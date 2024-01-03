class AddAdminApprovedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin_approved, :boolean
  end
end
