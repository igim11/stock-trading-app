class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_id
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
