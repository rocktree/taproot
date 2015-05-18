# == Schema Information
#
# Table name: documents
#
#  id            :integer          not null, primary key
#  site_id       :integer
#  document_uid  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  idx           :integer          default(0)
#  crop_data     :text
#  document_site :string(255)
#  document_name :string(255)
#

class Document < ActiveRecord::Base

  # ------------------------------------------ Plugins

  dragonfly_accessor :document

  has_paper_trail

  # ------------------------------------------ Attributes

  serialize :crop_data, Hash

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true

  # ------------------------------------------ Scopes

  scope :by_idx, -> { reorder('idx asc') }

  # ------------------------------------------ Callbacks

  after_create :create_idx

  after_save :cache_attrs

  def cache_attrs
    update_columns(
      :document_site => site.slug,
      :document_name => self.document.meta['name']
    )
  end

  # ------------------------------------------ Instance Methods

  def to_param
    idx.to_s
  end

  def create_idx
    last_obj = self.site.documents.by_idx.last
    idx = last_obj.idx + 1
    update_columns(:idx => idx)
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      crop_data.keys.include?(method.to_s) ? crop(method.to_s) : super
    end
  end

  def respond_to?(method, include_private = false)
    begin
      super
    rescue
      crop_data.keys.include?(method.to_s) ? true : false
    end
  end

  def croppings
    begin
      crop_data.keys
    rescue
      []
    end
  end

  def crop(version)
    unless crop_data[version].blank?
      hash = crop_data[version].map { |k,v| {k => v.to_f} }.reduce(:merge)
      OpenStruct.new(hash)
    end
  end

  def crop_url(version)
    if version == 'full'
      document.url
    else
      c = crop(version)
      if c.nil?
        nil
      else
        magic  = "#{c.crop_width.to_i}x#{c.crop_height.to_i}"
        magic += "+#{c.x.to_i}+#{c.y.to_i}"
        document.thumb(magic).thumb("#{c.width.to_i}x#{c.height.to_i}#").url
      end
    end
  end

  def is_image?
    begin
      %w{jpg jpeg png gif}.include?(document.ext.downcase)
    rescue
      false
    end
  end

  def has_thumbnail?
    begin
      is_image? || document.ext == 'pdf'
    rescue
      false
    end
  end

  def thumbnail
    if document
      size = '250'
      if is_image?
        document.thumb("#{size}x#{size}#").url
      elsif document.ext == 'pdf'
        document.thumb("#{size}x#{size}#", :format => 'png', :frame => 0).url
      end
    end
  end

end
