module ActivityLog
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    has_paper_trail

    after_save :cache_references

    has_one :reference_cache, :as => :item
  end

  def cache_references
    ref = reference_cache
    if ref.nil?
      ref = ReferenceCache.create(:item => self)
    end
    case self.class.to_s
    when 'Site'
      site = self
      path = builder_site_path(site)
    when 'Page', 'Document', 'Form', 'Menu', 'Template', 'ResourceType'
      path = send("builder_site_#{self.class.table_name.singularize}_path",
                  self.site, self)
    when 'FormField', 'TemplateField'
      parent = self.class.to_s.tableize.split("_").first
      path = send("builder_site_#{parent}_#{parent}_field_path",
                  self.site, self.send(parent), self)
    when 'Resource', 'ResourceField', 'ResourceAssociationField'
      path = send(
        "builder_site_resource_type_#{self.class.table_name.singularize}_path",
        self.site, self.resource_type, self)
    when 'MenuItem'
      path = send("builder_site_menu_menu_item_path", self.site, menu, self)
    end
    site = self.site if site.nil?
    ref.update_columns(
      :site_title => site.title,
      :site_path => builder_site_path(site),
      :item_path => path
    )
  end

  def cache
    reference_cache
  end

end
