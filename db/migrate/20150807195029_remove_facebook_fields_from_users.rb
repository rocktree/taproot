class RemoveFacebookFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_columns :users, :fb_access_token
    remove_columns :users, :fb_token_expires
  end
end
