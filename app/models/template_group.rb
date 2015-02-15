# == Schema Information
#
# Table name: template_groups
#
#  id          :integer          not null, primary key
#  template_id :integer
#  title       :string(255)
#  slug        :string(255)
#  position    :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

class TemplateGroup < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include TemplateSlug

  # ------------------------------------------ Associations

  belongs_to :template, :touch => true

  has_one :site, :through => :template

  has_many :template_fields, :dependent => :destroy

  # accepts_nested_attributes_for :template_fields

  # ------------------------------------------ Scopes

  scope :in_order, -> { order('position asc') }

  # ------------------------------------------ Callbacks

  before_save :set_position

  def set_position
    self.position = 1 if self.position.blank?
  end

  # ------------------------------------------ Instance Methods

  def fields
    template_fields
  end

end
