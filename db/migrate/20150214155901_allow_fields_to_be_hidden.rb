class AllowFieldsToBeHidden < ActiveRecord::Migration
  def change
    add_column :template_fields, :hidden, :boolean, :default => false
    add_column :template_fields, :can_be_hidden, :boolean, :default => true

    TemplateField.all.each do |field|
      if field.slug == 'title'
        field.update_columns(:can_be_hidden => false)
      end
    end
  end
end
