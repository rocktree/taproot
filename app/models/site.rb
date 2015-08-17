# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  git_url    :string(255)
#  uid        :string(255)
#  config     :json
#

require 'active_support/inflector'
require 'yaml'

class Site < ActiveRecord::Base

  # ------------------------------------------ Plugins

  has_superslug

  # ------------------------------------------ Associations

  has_many :site_users
  has_many :users, :through => :site_users
  # has_many :templates, :dependent => :destroy
  # has_many :resource_types, :dependent => :destroy
  has_many :webpages, :dependent => :destroy, :class_name => 'Page'
  # has_many :forms, :dependent => :destroy
  # has_many :documents, :dependent => :destroy
  # has_many :menus, :dependent => :destroy
  # has_many :menu_items, :through => :menus
  # has_many :site_settings, :dependent => :destroy
  # has_many :domains, :dependent => :destroy

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }
  scope :last_updated, -> { order('updated_at desc') }

  # ------------------------------------------ Validations

  validates :title, :presence => true

  validates_uniqueness_of :title, :uid

  validates_format_of :title, :with => /\A[A-Za-z][A-Za-z0-9\ ]+\z/

  # ------------------------------------------ Callbacks

  before_create :generate_uid

  def generate_uid
    self.uid = SecureRandom.hex(9)
  end

  after_create :generate_default_config

  def generate_default_config
    convert_title_to_slug # superslug runs this
    config = { :title => title, :slug => slug, :uid => uid }
    config_will_change!
    update_columns(:config => config)
  end

  # ------------------------------------------ Instance Method

  def pages
    @pages ||= Rails.env.production? ? webpages.published : webpages
  end

  def to_param
    uid
  end

  # def templates
  #   TemplateCollection.new(self)
  # end

  def update_config(attrs = {})
    attrs.each do |key, value|
      if ['title','slug','uid'].include?(key.to_s)
        update_columns(key.to_sym => value)
      end
    end
    conf = self.config.merge(attrs)
    config_will_change!
    update_columns(:config => conf)
  end

  # def files
  #   documents
  # end

  # def redirect_domains
  #   return [] if secondary_urls.blank?
  #   secondary_urls.split("\n").collect(&:strip)
  # end

  # def update_config!
  #   config_dir = "#{Rails.root}/projects/#{slug}/config"
  #   templates = YAML.load(File.read("#{config_dir}/templates.yml")).to_json
  #   update_columns(:templates => templates)
  # end

  # def method_missing(method, *arguments, &block)
  #   begin
  #     super
  #   rescue
  #     # This enables us to call a template and will return
  #     # all the pages for that template
  #     template = templates.find_by_slug(method)
  #     if template.nil?
  #       singular_method = ActiveSupport::Inflector.singularize(method)
  #       template = templates.find_by_slug(singular_method)
  #     end
  #     if template.nil?
  #       super
  #     else
  #       template.pages
  #     end
  #   end
  # end

  # def respond_to?(method, include_private = false)
  #   template = templates.find_by_slug(method)
  #   if template.nil?
  #     singular_method = ActiveSupport::Inflector.singularize(method)
  #     template = templates.find_by_slug(singular_method)
  #   end
  #   template.nil? ? super : true
  # end

  # ------------------------------------------ Deprecated Methods

  # def page_types
  #   templates
  # end

  # def settings
  #   site_settings
  # end

end
