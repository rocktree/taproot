namespace :taproot do
  namespace :update do

    task :one_one => :environment do
      Template.all.each do |template|

        slug = template.slug.gsub(/\-/, '_')

        children = []
        template.children.each do |child|
          unless child.blank?
            children << child.gsub(/\-/, '_')
          end
        end

        template.update!(
          :can_be_root => true,
          :slug => slug,
          :children => children
        )

        template.page_templates.split("\n").reject(&:blank?).each do |pt|
          pt = pt.strip
          if pt == template.slug
            template.add_default_fields
          else
            new_template = template.dup
            new_template.slug = pt
            new_template.title = pt.titleize
            new_template.save!

            template.template_groups.each do |group|
              new_group = group.dup
              new_group.template = new_template
              new_group.save!

              group.template_fields.each do |field|
                new_field = field.dup
                new_field.template_group = new_group
                new_field.save!
              end
            end
          end
        end
      end

      Page.all.includes(:template => [:site]).each do |page|
        t_slug = page.old_template_ref.gsub(/\-/, '_')
        template = page.site.templates.find_by_slug(t_slug)
        unless template == page.template
          page.template = template
          page.save!
        end
      end
    end

  end
end
