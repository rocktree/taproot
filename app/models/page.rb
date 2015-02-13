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
#

class Page < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include PageTypeSlug

  has_ancestry

  # ------------------------------------------ Attributes

  serialize :field_data, Hash

  # ------------------------------------------ Associations

  belongs_to :template, :touch => true

  has_one :site, :through => :template

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

  after_save :cache_order_by

  def cache_order_by
    order_by = self.template.order_method
    unless order_by.blank?
      update_columns(:order => self.send(order_by))
    end
  end

  # ------------------------------------------ Instance Methods

  def respond_to_fields
    field_data.keys
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      if respond_to_fields.include?(method.to_s)
        if method.to_s =~ /image/
          site.documents.find_by_idx(field_data[method.to_s])
        else
          field_data[method.to_s]
        end
      else
        super
      end
    end
  end

  def respond_to?(method, include_private = false)
    begin
      super
    rescue
      respond_to_fields.include?(method.to_s) ? true : false
    end
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

end
