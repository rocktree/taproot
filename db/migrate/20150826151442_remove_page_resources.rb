class RemovePageResources < ActiveRecord::Migration
  def change
    drop_table :page_resources
  end
end
