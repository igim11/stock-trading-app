class RenameUseridToUserIdInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :userid, :user_id
  end
end
