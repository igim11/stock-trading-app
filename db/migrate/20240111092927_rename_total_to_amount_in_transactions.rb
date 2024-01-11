class RenameTotalToAmountInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :total, :amount
  end
end
