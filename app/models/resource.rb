# == Schema Information
#
# Table name: resources
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  slug             :string(255)
#  resource_type_id :integer
#  field_data       :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Resource < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include ActivityLog

  has_superslug :title, :slug, :context => :resource_type

  # ------------------------------------------ Attributes

  serialize :field_data, Hash

  # ------------------------------------------ Associations

  belongs_to :resource_type

  has_one :site, :through => :resource_type

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Callbacks

  after_save :check_field_data

  def check_field_data
    fd = field_data
    if missing_fields.size > 0
      missing_fields.each do |field|
        fd[field] = ''
      end
    end
    update_columns(:field_data => fd)
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
        field_data[method.to_s]
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

  def missing_fields
    resource_type.fields.collect(&:slug) - ['title','slug'] - field_data.keys
  end

end
