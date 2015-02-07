# == Schema Information
#
# Table name: template_fields
#
#  id                :integer          not null, primary key
#  template_group_id :integer
#  title             :string(255)
#  slug              :string(255)
#  data_type         :string(255)
#  options           :text
#  required          :boolean          default(FALSE)
#  position          :integer          default(0)
#  created_at        :datetime
#  updated_at        :datetime
#  protected         :boolean          default(FALSE)
#

class TemplateField < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include FieldSlug

  # ------------------------------------------ Associations

  belongs_to :group, :class_name => 'TemplateGroup', :touch => true

  has_one :template, :through => :group
  has_one :site, :through => :page_type

  # ------------------------------------------ Scopes

  default_scope { order('position asc') }

  # ------------------------------------------ Instance Methods

  def group
    page_type_field_group
  end

  def option_values
    options.gsub(/\r/, '').split("\n") unless options.blank?
  end

end
