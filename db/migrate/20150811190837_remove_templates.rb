class RemoveTemplates < ActiveRecord::Migration
  def change
    drop_table :templates
    drop_table :template_descendants
    drop_table :template_fields
    drop_table :template_groups
    drop_table :template_resource_types
  end
end
