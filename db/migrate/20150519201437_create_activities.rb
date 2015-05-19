class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :item_type
      t.integer :item_id
      t.string :item_path
      t.integer :site_id
      t.integer :user_id

      t.timestamps
    end

    # add_column :documents, :last_editor_id, :integer
    # add_column :forms, :last_editor_id, :integer
    # add_column :form_fields, :last_editor_id, :integer
    # add_column :menus, :last_editor_id, :integer
    # add_column :menu_items, :last_editor_id, :integer
    # add_column :resources, :last_editor_id, :integer
    # add_column :resource_association_fields, :last_editor_id, :integer
    # add_column :resource_fields, :last_editor_id, :integer
    # add_column :sites, :last_editor_id, :integer
    # add_column :template_fields, :last_editor_id, :integer
  end

  # def up
  #   [
  #     Document, Form, FormField, Menu, MenuItem, Page, Resource,
  #     ResourceAssociationField, ResourceField, ResourceType,
  #     Site, Template, TemplateField
  #   ].each do |model|
  #     unless model.column_names.include?('last_editor_id')
  #       add_column model.table_name.to_sym, :last_editor_id, :integer
  #     end
  #   end
  # end

  # def down
  #   remove_column :documents, :last_editor_id, :integer
  #   remove_column :forms, :last_editor_id, :integer
  #   remove_column :form_fields, :last_editor_id, :integer
  #   remove_column :menus, :last_editor_id, :integer
  #   remove_column :menu_items, :last_editor_id, :integer
  #   remove_column :resources, :last_editor_id, :integer
  #   remove_column :resource_association_fields, :last_editor_id, :integer
  #   remove_column :resource_fields, :last_editor_id, :integer
  #   remove_column :sites, :last_editor_id, :integer
  #   remove_column :template_fields, :last_editor_id, :integer
  # end
end
