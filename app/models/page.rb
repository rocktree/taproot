# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  template_id      :integer
#  title            :string(255)
#  slug             :string(255)
#  description      :text
#  body             :text
#  ancestry         :string(255)
#  published        :boolean          default(FALSE)
#  field_data       :text
#  created_at       :datetime
#  updated_at       :datetime
#  position         :integer          default(0)
#  old_template_ref :string(255)
#  order            :string(255)
#  show_in_nav      :boolean          default(TRUE)
#  body_md          :text
#  page_path        :string(255)
#  last_editor_id   :integer
#

require 'active_support/inflector'

class Page < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include PgSearch, ActivityLog

  has_ancestry

  has_superslug :title, :slug, :context => :site

  pg_search_scope(
    :search_content,
    :against => [:title, :body],
    :using => {
      :tsearch => {:dictionary => "english"}
    }
  )

  # ------------------------------------------ Attributes

  serialize :field_data, Hash

  # ------------------------------------------ Associations

  belongs_to :template, :touch => true
  belongs_to :last_editor, :class_name => 'User'

  has_one :site, :through => :template

  has_many :page_documents, :dependent => :destroy
  has_many :documents, :through => :page_documents
  has_many :page_resources, :dependent => :destroy
  has_many :resources, :through => :page_resources
  has_many :resource_types, :through => :template
  has_many :menu_items

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }
  scope :published, -> { where(:published => true) }
  scope :asc, -> { order('pages.order asc') }
  scope :desc, -> { order('pages.order desc') }
  scope :navigatable, -> { where(:show_in_nav => true) }
  scope :alpha, -> { order('title asc') }

  # ------------------------------------------ Validations

  validates :title, :template, :presence => true

  # ------------------------------------------ Callbacks

  after_commit :cache_order_by

  def cache_order_by
    order_by = self.template.order_method
    unless order_by.blank?
      update_columns(:order => self.send(order_by))
    end
  end

  after_save :check_template_fields

  def check_template_fields
    fd = field_data
    if missing_fields.size > 0
      missing_fields.each do |field|
        fd[field] = ''
      end
    end
    update_columns(:field_data => fd)
  end

  after_save :cache_page_path

  def cache_page_path
    update_columns(:page_path => "/#{path.collect(&:slug).join('/')}")
  end

  after_save :save_children, :if => :slug_changed?

  def save_children
    children.each(&:save!)
  end

  after_save :check_template_maxed

  def check_template_maxed
    template.check_maxed_out
  end

  after_save :parse_markdown

  def parse_markdown
    if body_md_changed?
      update_columns(:body => SapwoodMarkdown.to_html(body_md))
    end
    field_data.each do |key, data|
      if key.to_s =~ /^markdown\_/ && data.present?
        html = SapwoodMarkdown.to_html(data)
        field_data_will_change!
        fd = field_data.merge(
          :"#{key.to_s.gsub(/^markdown\_/, '')}" => html
        )
        update_columns(:field_data => fd)
      end
    end
  end

  # ------------------------------------------ Instance Methods

  def resource_type_methods
    resource_types.map { |rt| rt.slug.pluralize }
  end

  def respond_to_fields
    field_data.keys + resource_type_methods
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      if respond_to_fields.include?(method.to_s)
        singular_method = ActiveSupport::Inflector.singularize(method.to_s)
        if resource_type_methods.include?(method.to_s)
          rt = resource_types.select { |rt|
            [method.to_s, singular_method].include?(rt.slug)
          }.first
          if rt.nil?
            super
          else
            page_resources.where(:resource_id => rt.resources.collect(&:id))
              .includes(:resource)
          end
        elsif field_data["rtfile_#{method.to_s}"].present? ||
              method.to_s =~ /image/
          site.documents.find_by_idx(field_data[method.to_s])
        else
          field_data[method.to_s]
        end
      elsif method.to_s =~ /^markdown\_/
        field_data[method.to_s]
      else
        super
      end
    end
  end

  def respond_to?(method, include_private = false)
    respond_to_fields.include?(method.to_s) ? true : super
  end

  def missing_fields
    template.fields.collect(&:slug) -
      ['title','description','body','show_in_nav','slug','position'] -
      field_data.keys
  end

  def dropdown_label
    "#{title} #{"[#{page_path}]" unless page_path.blank?}"
  end

  # ------------------------------------------ Class Methods

  def self.order_by_fields
    ['title','slug','position','created_at','updated_at']
  end

  # ------------------------------------------ Deprecated Methods

  def page_type
    template
  end

  def draft?
    !published?
  end

  def status
    published? ? 'published' : 'draft'
  end

end
