class AddDeveloperTemplateFieldsToTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :filename, :string
    remove_column :templates, :label, :string

    rename_column :templates, :children, :parents
    rename_column :templates, :order_by, :order_method

    add_column :templates, :order_direction, :string
    add_column :templates, :can_be_root, :boolean, :default => false
    add_column :templates, :limit_pages, :boolean, :default => false
    add_column :templates, :max_pages, :integer
  end
end
