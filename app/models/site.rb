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

class Site < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include Slug

  # ------------------------------------------ Attributes

  serialize :crop_settings, Hash

  attr_accessor :new_repo

  # ------------------------------------------ Associations

  has_many :site_users
  has_many :users, :through => :site_users
  has_many :templates, :dependent => :destroy
  has_many :pages, :through => :templates, :dependent => :destroy
  has_many :forms, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :image_croppings

  belongs_to :home_page, :class_name => 'Page'

  accepts_nested_attributes_for :image_croppings

  # ------------------------------------------ Scopes

  scope :last_updated, -> { order('updated_at desc') }

  # ------------------------------------------ Validations

  validates :title, :git_url, :presence => true

  validates_uniqueness_of :title

  validates_format_of :title, :with => /\A[A-Za-z][A-Za-z\ ]+\z/

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

  def class_file
    slug.gsub(/\-/, '_')
  end

  def settings
    file = File.join(Rails.root,'config','sites',"#{class_file}.yml")
    if File.exists?(file)
      YAML.load_file(file)[Rails.env].to_ostruct
    else
      OpenStruct.new
    end
  end

  def files
    documents
  end

  def redirect_domains
    return [] if secondary_urls.blank?
    secondary_urls.split("\n").collect(&:strip)
  end

  # ------------------------------------------ Deprecated Methods

  def page_types
    templates
  end

end
