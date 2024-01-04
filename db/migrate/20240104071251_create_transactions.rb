class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :userid
      t.string :action
      t.string :stock
      t.decimal :shares
      t.decimal :price
      t.decimal :total

      t.timestamps
    end
  end
end
