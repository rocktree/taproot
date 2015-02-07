require 'csv'

namespace :taproot do
  namespace :update do

    desc 'Prepapre data for v1.1'
    task :one_one => :environment do

      # Save template form groups
      fields_file = Rails.root.join('db','backups','csv','page_type_fields.csv')
      CSV.foreach(fields_file, :headers => true) do |row|
        puts row["page_type_field_group_id"]
      end
      # PageTypeField.all.includes(:page_type).each do |field|
      #   field.update_columns(:page_type_field_group_id => field.page_type.id)
      # end

      # PageType.all.includes(:fields).each do |page_type|
      #   fields = page_type.fields
      #   page_type.templates.each do |template|
      #     if page_type.slug == template
      #       page_type.update(:page_templates => template)
      #     else
      #       new_page_type = page_type.dup
      #       new_page_type.title = template.titleize
      #       new_page_type.slug = nil
      #       new_page_type.page_templates = template
      #       new_page_type.save!
      #       fields.each do |field|
      #         field = field.dup
      #         field.page_type_field_group_id = new_page_type.id
      #         field.save!
      #       end
      #     end
      #   end
      # end
    end

  end
end
