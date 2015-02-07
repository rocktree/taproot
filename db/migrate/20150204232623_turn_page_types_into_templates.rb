class TurnPageTypesIntoTemplates < ActiveRecord::Migration
  def up
    drop_table :page_type_field_groups
    drop_table :page_type_fields

    rename_column :pages, :page_type_id, :template_id

    rename_table :page_types, :templates

    remove_column :templates, :page_templates, :string
    remove_column :templates, :label, :string

    rename_column :templates, :children, :parents
    rename_column :templates, :order_by, :order_method

    add_column :templates, :order_direction, :string
    add_column :templates, :can_be_root, :boolean, :default => false
    add_column :templates, :limit_pages, :boolean, :default => false
    add_column :templates, :max_pages, :integer
    add_column :templates, :form_groups, :text
    add_column :templates, :form_fields, :text
  end
end
