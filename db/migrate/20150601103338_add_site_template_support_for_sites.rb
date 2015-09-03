class AddSiteTemplateSupportForSites < ActiveRecord::Migration
  def change
    add_column :sites, :template_url, :string
    remove_column :sites, :description, :text
  end
end
