class AddUidToSites < ActiveRecord::Migration
  def change
    add_column :sites, :uid, :string
  end
end
