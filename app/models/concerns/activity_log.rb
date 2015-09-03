module ActivityLog
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers

    has_paper_trail

    after_commit :save_activity

    has_many :activities, :as => :item
  end

  def save_activity
    site = self.site
    Activity.create(
      :item => self,
      :site => self.site,
      :item_path => editor_path_ref,
      :user => RequestStore.store[:topkit],
      :action => self.new_record? ? 'created' : 'updated'
    )
    Activity.where(:item => self).update_all(:item_path => editor_path_ref)
  end

  def editor_path_ref
    case self.class.to_s
    when 'Site'
      path = site_editor_path(self.site)
    when 'FormField', 'TemplateField'
      parent = self.class.to_s.tableize.split("_").first
      path = send("site_editor_#{parent}_#{parent}_field_path",
                  self.site, self.send(parent), self)
    when 'Resource', 'ResourceField', 'ResourceAssociationField'
      path = send(
        "site_editor_resource_type_#{self.class.table_name.singularize}_path",
        self.site, self.resource_type, self)
    when 'MenuItem'
      path = send("site_editor_menu_menu_item_path", self.site, menu, self)
    else
      path = send("site_editor_#{self.class.table_name.singularize}_path",
                  self.site, self)
    end
  end

end
