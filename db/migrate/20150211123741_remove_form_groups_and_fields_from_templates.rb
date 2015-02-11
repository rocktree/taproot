class RemoveFormGroupsAndFieldsFromTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :form_fields, :text
    remove_column :templates, :form_groups, :text

    rename_column :pages, :template, :old_template_ref
  end
end
