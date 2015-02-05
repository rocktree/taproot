class AddTemplatingFields < ActiveRecord::Migration
  def change
    rename_column :pages, :page_type_id, :template_id
    rename_column :templates, :page_templates, :filename
  end
end
