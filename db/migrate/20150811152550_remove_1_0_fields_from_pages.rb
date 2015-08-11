class Remove10FieldsFromPages < ActiveRecord::Migration
  def change
     remove_column :pages, :template_id
     remove_column :pages, :description
     remove_column :pages, :old_template_ref
     remove_column :pages, :order
     remove_column :pages, :show_in_nav
     remove_column :pages, :body_md
     remove_column :pages, :last_editor_id
  end
end
