class AddConfigToSites < ActiveRecord::Migration
  def change
    add_column :sites, :config, :json
  end
end
