# == Schema Information
#
# Table name: templates
#
#  id          :integer          not null, primary key
#  site_id     :integer
#  title       :string(255)
#  slug        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  filename    :text
#  children    :text
#  label       :string(255)
#  order_by    :string(255)
#

class Template < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug

  # ------------------------------------------ Attributes

  attr_accessor :delete_group

  serialize :children, Array

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true

  has_many :pages
  has_many :template_fields

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }

  # ------------------------------------------ Validations

  validates :title, :presence => true

end
