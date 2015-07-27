class RemoveDomainsFromSites < ActiveRecord::Migration
  def change
    remove_column :sites, :url
    remove_column :sites, :secondary_urls
    remove_column :sites, :template_url
    remove_column :sites, :home_page_id
  end
end
