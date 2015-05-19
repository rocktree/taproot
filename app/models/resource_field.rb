# == Schema Information
#
# Table name: resource_fields
#
#  id               :integer          not null, primary key
#  resource_type_id :integer
#  title            :string(255)
#  slug             :string(255)
#  data_type        :string(255)
#  options          :text
#  required         :boolean          default(FALSE)
#  position         :integer          default(0)
#  label            :string(255)
#  protected        :boolean          default(FALSE)
#  default_value    :string(255)
#  half_width       :boolean          default(FALSE)
#  hidden           :boolean          default(FALSE)
#  can_be_hidden    :boolean          default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

class ResourceField < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include ResourceTypeSlug, ActivityLog

  # ------------------------------------------ Associations

  belongs_to :resource_type

  has_one :site, :through => :resource_type

  # ------------------------------------------ Scopes

  scope :alpha, -> { reorder('title asc') }
  scope :in_position, -> { order('position asc') }

  # ------------------------------------------ Validations

  validates :title, :resource_type_id, :data_type, :presence => true
  validate :required_and_hidden

  # ------------------------------------------ Callbacks

  before_save :verify_label

  def verify_label
    self.label = self.title if self.label.blank?
  end

  # ------------------------------------------ Instance Methods

  def optional?
    !required?
  end

  def option_values
    options.gsub(/\r/, '').split("\n") unless options.blank?
  end

  private

    def required_and_hidden
      if required? && hidden?
        errors.add(:hidden, "can't be required AND hidden")
      end
    end

end
