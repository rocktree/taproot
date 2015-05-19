# == Schema Information
#
# Table name: menu_items
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  page_id    :integer
#  title      :string(255)
#  slug       :string(255)
#  url        :string(255)
#  position   :integer          default(0)
#  ancestry   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MenuItem < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug, ActivityLog

  has_ancestry

  # ------------------------------------------ Attributes

  attr_accessor :in_list

  # ------------------------------------------ Associations

  belongs_to :menu, :touch => true
  belongs_to :page

  has_one :site, :through => :menu

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Callbacks

  after_save :check_page_path

  def check_page_path
    unless page_id.blank?
      path = page.page_path
      update_columns(:url => path) unless path == url
    end
  end

  before_save :check_parent

  def check_parent
    unless in_list.blank?
      page = site.menu_items.find_by_slug(in_list)
      self.parent_id = page.id unless page.nil?
    end
  end

  # ------------------------------------------ Instance Methods

  def label
    title
  end

end
