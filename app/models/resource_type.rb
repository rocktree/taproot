# == Schema Information
#
# Table name: resource_types
#
#  id              :integer          not null, primary key
#  site_id         :integer
#  title           :string(255)
#  slug            :string(255)
#  description     :text
#  order_method    :string(255)
#  order_direction :string(255)
#  last_editor_id  :integer
#  has_show_view   :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#

class ResourceType < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug, ActivityLog

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true
  belongs_to :last_editor, :class_name => 'User'

  has_many :template_resource_types
  has_many :templates, :through => :template_resource_types

  has_many :resources, :dependent => :destroy
  has_many :resource_fields, :dependent => :destroy
  has_many :resource_association_fields, :dependent => :destroy

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Callbacks

  after_create :add_default_fields

  def add_default_fields
    self.fields.create!([
      {
        :title => 'Title',
        :slug => 'title',
        :data_type => 'string',
        :required => true,
        :position => 1,
        :protected => true,
        :can_be_hidden => false
      },
      {
        :title => 'Slug',
        :slug => 'slug',
        :data_type => 'string',
        :required => false,
        :position => 2,
        :protected => true
      }
    ])
  end

  # ------------------------------------------ Instance Methods

  def fields
    resource_fields
  end

  def association_fields
    resource_association_fields
  end

  def assoc_fields
    resource_association_fields
  end

end
