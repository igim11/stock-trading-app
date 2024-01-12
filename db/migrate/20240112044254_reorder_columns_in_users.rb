class ReorderColumnsInUsers < ActiveRecord::Migration[7.1]
  def up
    # Create a new table with the desired column order
    create_table :users_temp do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_id
      t.string :email, default: "", null: false
      t.string :encrypted_password, default: "", null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :admin_approved
      t.string :status
      t.decimal :cash
      t.timestamp :remember_created_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    # Copy data from the old table to the new one
    execute('INSERT INTO users_temp (first_name, last_name, user_id, email, encrypted_password, reset_password_token, reset_password_sent_at, admin_approved, status, cash, remember_created_at, created_at, updated_at) SELECT first_name, last_name, user_id, email, encrypted_password, reset_password_token, reset_password_sent_at, admin_approved, status, cash, remember_created_at, created_at, updated_at FROM users;')

    # Drop existing indexes in the new table
    remove_index :users_temp, name: "index_users_on_email"
    remove_index :users_temp, name: "index_users_on_reset_password_token"

    # Recreate indexes in the new table
    add_index :users_temp, :email, name: "index_users_on_email", unique: true
    add_index :users_temp, :reset_password_token, name: "index_users_on_reset_password_token", unique: true

    # Rename tables
    rename_table :users, :users_old
    rename_table :users_temp, :users
  end

  def down
    # Drop the new table
    drop_table :users

    # Rename the old table back to the original name
    rename_table :users_old, :users
  end
end
