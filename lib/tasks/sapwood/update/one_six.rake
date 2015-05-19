namespace :sapwood do
  namespace :update do

    task :one_six => :environment do
      PaperTrail::Version.destroy_all
      [
        Document, Form, FormField, Menu, MenuItem, Page, Resource,
        ResourceAssociationField, ResourceField, ResourceType,
        Site, Template, TemplateField
      ].each do |model|
        model.all.shuffle.first(3).each { |item| item.save }
      end
      Activity.update_all(:user_id => 1)
      PaperTrail::Version.update_all(:whodunnit => 1)
    end
  end
end
