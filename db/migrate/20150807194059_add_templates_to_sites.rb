class AddTemplatesToSites < ActiveRecord::Migration
  def change
    add_column :sites, :templates, :json
  end
end
