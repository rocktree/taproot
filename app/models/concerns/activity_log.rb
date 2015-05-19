module ActivityLog
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    has_paper_trail

    after_save :save_activity

    has_many :activities, :as => :item
  end

  def save_activity
    site = self.site
    Activity.create(
      :item => self,
      :site => self.site,
      :item_path => builder_path_ref,
      :user => RequestStore.store[:sapwood]
    )
    Activity.where(:item => self).update_all(:item_path => builder_path_ref)
  end

  def builder_path_ref
    case self.class.to_s
    when 'Site'
      path = builder_site_path(self.site)
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
  end

end
