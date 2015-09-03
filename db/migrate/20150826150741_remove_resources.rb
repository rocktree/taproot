class RemoveResources < ActiveRecord::Migration
  def change
    drop_table :resources
    drop_table :resource_association_fields
    drop_table :resource_fields
    drop_table :resource_types
  end
end
