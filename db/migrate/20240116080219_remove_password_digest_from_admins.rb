class RemovePasswordDigestFromAdmins < ActiveRecord::Migration[7.1]
  def change
    remove_column :admins, :password_digest, :string
  end
end
