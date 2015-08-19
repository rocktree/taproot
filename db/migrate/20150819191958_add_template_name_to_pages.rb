class AddTemplateNameToPages < ActiveRecord::Migration
  def change
    add_column :pages, :template_name, :string
  end
end
