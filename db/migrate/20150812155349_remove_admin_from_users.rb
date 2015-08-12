class RemoveAdminFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin, :boolean
    remove_column :site_users, :site_admin, :boolean
  end
end
