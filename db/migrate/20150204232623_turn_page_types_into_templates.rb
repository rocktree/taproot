class TurnPageTypesIntoTemplates < ActiveRecord::Migration
  def up
    # Template Groups
    rename_table :page_type_field_groups, :template_groups

    rename_column :template_groups, :page_type_id, :template_id

    # Template Fields
    rename_table :page_type_fields, :template_fields

    rename_column :template_fields, :page_type_field_group_id, :template_group_id

    add_column :template_fields, :label, :string
    add_column :template_fields, :protected, :boolean, :default => false

    # Pages
    rename_column :pages, :page_type_id, :template_id

    # Templates
    rename_table :page_types, :templates

    # Template.all.each do |template|
    #   template.page_templates.split("\n").reject(&:blank?).each do |filename|
    #     unless template.slug == filename
    #       t = template.dup
    #       t.slug = filename
    #       t.title = filename.titleize
    #       t.save!
    #       template.fields.each do |field|
    #         f = field.dup
    #         f.template_group_id = t.id
    #         f.save!
    #       end
    #     end
    #   end
    # end

    # remove_column :templates, :page_templates, :string
    remove_column :templates, :label, :string

    # rename_column :templates, :children, :parents
    rename_column :templates, :order_by, :order_method

    add_column :templates, :order_direction, :string
    add_column :templates, :can_be_root, :boolean, :default => false
    add_column :templates, :limit_pages, :boolean, :default => false
    add_column :templates, :max_pages, :integer, :default => 0
    add_column :templates, :maxed_out, :boolean, :default => false
    add_column :templates, :form_groups, :text
    add_column :templates, :form_fields, :text
  end
end
