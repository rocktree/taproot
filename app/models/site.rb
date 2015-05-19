# == Schema Information
#
# Table name: sites
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  slug           :string(255)
#  url            :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#  home_page_id   :integer
#  git_url        :string(255)
#  secondary_urls :text
#

require 'active_support/inflector'

class Site < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include Slug, ActivityLog

  # ------------------------------------------ Attributes

  serialize :crop_settings, Hash

  attr_accessor :new_repo

  # ------------------------------------------ Associations

  has_many :site_users
  has_many :users, :through => :site_users
  has_many :templates, :dependent => :destroy
  has_many :resource_types, :dependent => :destroy
  has_many :webpages, :through => :templates, :dependent => :destroy,
           :class_name => 'Page'
  has_many :forms, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :image_croppings, :dependent => :destroy
  has_many :menus, :dependent => :destroy
  has_many :menu_items, :through => :menus
  has_many :site_settings, :dependent => :destroy

  belongs_to :home_page, :class_name => 'Page'

  accepts_nested_attributes_for :image_croppings

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }
  scope :last_updated, -> { order('updated_at desc') }

  # ------------------------------------------ Validations

  validates :title, :git_url, :presence => true

  validates_uniqueness_of :title

  validates_format_of :title, :with => /\A[A-Za-z][A-Za-z0-9\ ]+\z/

  # ------------------------------------------ Callbacks

  after_save :remove_blank_image_croppings

  def remove_blank_image_croppings
    image_croppings.where("title = ''").destroy_all
  end

  after_save :reload_routes

  def reload_routes
    if secondary_urls_changed? || url_changed?
      Rails.application.reload_routes!
    end
  end

  # ------------------------------------------ Instance Method

  def croppers
    crop_settings
  end

  def files
    documents
  end

  def redirect_domains
    return [] if secondary_urls.blank?
    secondary_urls.split("\n").collect(&:strip)
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      # This enables us to call a template and will return
      # all the pages for that template
      template = templates.find_by_slug(method)
      if template.nil?
        singular_method = ActiveSupport::Inflector.singularize(method)
        template = templates.find_by_slug(singular_method)
      end
      if template.nil?
        super
      else
        template.pages
      end
    end
  end

  def respond_to?(method, include_private = false)
    template = templates.find_by_slug(method)
    if template.nil?
      singular_method = ActiveSupport::Inflector.singularize(method)
      template = templates.find_by_slug(singular_method)
    end
    template.nil? ? super : true
  end

  # ------------------------------------------ Deprecated Methods

  def page_types
    templates
  end

  def pages
    Rails.env.production? ? webpages.published : webpages
  end

  def settings
    site_settings
  end

end
