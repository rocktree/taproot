# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  site_id         :integer
#  title           :string(255)
#  slug            :string(255)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  page_templates  :text
#  parents         :text
#  order_method    :string(255)
#  order_direction :string(255)
#  can_be_root     :boolean          default(FALSE)
#  limit_pages     :boolean          default(FALSE)
#  max_pages       :integer
#  form_groups     :text
#  form_fields     :text
#

class Template < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug

  # ------------------------------------------ Attributes

  serialize :parents, Array
  serialize :form_groups, Array
  serialize :form_fields, Array

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true

  has_many :pages
  has_many :groups, :class_name => 'TemplateGroup', :dependent => :destroy
  has_many :fields, :class_name => 'TemplateField', :through => :groups

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Instance Methods

  def template_groups
    groups
  end

end
