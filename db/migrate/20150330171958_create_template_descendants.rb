class CreateTemplateDescendants < ActiveRecord::Migration
  def change
    create_table :template_descendants do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end

    # Template.serialize(:children, Array)
    # Template.all.each do |template|
    # template.children.reject(&:blank?).each do |child|
    #     child_template = Template.find_by_slug(child.strip)
    #     unless child_template.nil?
    #       TemplateDescendant.create(
    #         :parent_id => template.id,
    #         :child_id => child_template.id
    #       )
    #     end
    #   end
    # end

    # remove_column :templates, :children
  end
end
