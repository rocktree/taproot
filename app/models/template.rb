# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  site_id         :integer
#  title           :string(255)
#  slug            :string(255)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  page_templates  :text
#  children        :text
#  order_method    :string(255)
#  order_direction :string(255)
#  can_be_root     :boolean          default(FALSE)
#  limit_pages     :boolean          default(FALSE)
#  max_pages       :integer          default(0)
#  maxed_out       :boolean          default(FALSE)
#  form_groups     :text
#  form_fields     :text
#

class Template < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug

  # ------------------------------------------ Attributes

  serialize :children, Array
  serialize :form_groups, Array
  serialize :form_fields, Array

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true

  has_many :webpages, :class_name => 'Page'
  has_many :template_groups, :dependent => :destroy
  has_many :template_fields, :through => :template_groups

  # ------------------------------------------ Scopes

  scope :alpha, -> { order('title asc') }
  scope :not_maxed_out, -> { where(:maxed_out => false) }
  scope :can_be_root, -> { where(:can_be_root => true) }

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Callbacks

  after_create :add_default_fields

  def add_default_fields
    group = self.groups.create!(:title => 'Details', :position => 0)
    fields = [
      {
        :title => 'Title',
        :slug => 'title',
        :data_type => 'string',
        :required => true,
        :position => 1,
        :protected => true
      },
      {
        :title => 'Position',
        :slug => 'position',
        :data_type => 'integer',
        :required => false,
        :position => 2,
        :protected => true
      },
      {
        :title => 'Description',
        :slug => 'description',
        :data_type => 'text',
        :required => false,
        :position => 3,
        :protected => true
      },
      {
        :title => 'Body',
        :slug => 'body',
        :data_type => 'text',
        :required => false,
        :position => 4,
        :protected => true
      },
      {
        :title => 'Show In Nav',
        :slug => 'show_in_nav',
        :data_type => 'boolean',
        :required => false,
        :position => 5,
        :protected => true
      },
    ].each do |field|
      group.fields.create(field.merge(:template_group => group))
    end
  end

  after_save :check_maxed_out

  def check_maxed_out
    if limit_pages? && pages.size >= max_pages
      update_columns(:maxed_out => true) if !maxed_out?
    else
      update_columns(:maxed_out => false) if maxed_out?
    end
  end

  # ------------------------------------------ Instance Methods

  def groups
    template_groups
  end

  def fields
    template_fields
  end

  def filename
    slug
  end

  def deletable?
    pages.size == 0 
  end

  def pages
    Rails.env.production? ? webpages.published : webpages
  end

end
