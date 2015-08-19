# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  body          :text
#  ancestry      :string(255)
#  published     :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#  page_path     :string(255)
#  site_id       :integer
#  field_data    :json
#  template_name :string(255)
#

require 'active_support/inflector'

class Page < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include PgSearch, ActivityLog, Presenter

  has_ancestry

  has_superslug :title, :slug, :context => :site

  pg_search_scope(
    :search_content,
    :against => [:title, :body],
    :using => {
      :tsearch => {:dictionary => "english"}
    }
  )

  # ------------------------------------------ Associations

  belongs_to :site

  # has_many :page_documents, :dependent => :destroy
  # has_many :documents, :through => :page_documents
  # has_many :page_resources, :dependent => :destroy
  # has_many :resources, :through => :page_resources
  # has_many :resource_types, :through => :template
  # has_many :menu_items

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }
  scope :published, -> { where(:published => true) }
  scope :asc, -> { order('pages.order asc') }
  scope :desc, -> { order('pages.order desc') }
  scope :navigatable, -> { where(:show_in_nav => true) }
  scope :alpha, -> { order('title asc') }

  # ------------------------------------------ Validations

  validates :title, :template_name, :site_id, :presence => true

  # ------------------------------------------ Callbacks

  after_save :cache_page_path

  def cache_page_path
    update_columns(:page_path => "/#{path.collect(&:slug).join('/')}")
  end

  after_save :save_children

  def save_children
    children.each(&:save!)
  end

  # ------------------------------------------ Instance Methods

  def template
    @template ||= site.templates.find(template_name)
  end

  # def resource_type_methods
  #   resource_types.map { |rt| rt.slug.pluralize }
  # end

  # def respond_to_fields
  #   field_data.keys + resource_type_methods
  # end

  # def method_missing(method, *arguments, &block)
  #   begin
  #     super
  #   rescue
  #     if respond_to_fields.include?(method.to_s)
  #       singular_method = ActiveSupport::Inflector.singularize(method.to_s)
  #       if resource_type_methods.include?(method.to_s)
  #         rt = resource_types.select { |rt|
  #           [method.to_s, singular_method].include?(rt.slug)
  #         }.first
  #         if rt.nil?
  #           super
  #         else
  #           page_resources.where(:resource_id => rt.resources.collect(&:id))
  #             .includes(:resource)
  #         end
  #       elsif field_data["rtfile_#{method.to_s}"].present? ||
  #             method.to_s =~ /image/
  #         site.documents.find_by_idx(field_data[method.to_s])
  #       else
  #         field_data[method.to_s]
  #       end
  #     elsif method.to_s =~ /^markdown\_/
  #       field_data[method.to_s]
  #     else
  #       super
  #     end
  #   end
  # end

  # def respond_to?(method, include_private = false)
  #   respond_to_fields.include?(method.to_s) ? true : super
  # end

  # def missing_fields
  #   template.fields.collect(&:slug) -
  #     ['title','description','body','show_in_nav','slug','position'] -
  #     field_data.keys
  # end

  # ------------------------------------------ Deprecated Methods

  def draft?
    !published?
  end

end
