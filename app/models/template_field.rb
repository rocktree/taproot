# == Schema Information
#
# Table name: template_fields
#
#  id                :integer          not null, primary key
#  template_group_id :integer
#  title             :string(255)
#  slug              :string(255)
#  data_type         :string(255)
#  options           :text
#  required          :boolean          default(FALSE)
#  position          :integer          default(0)
#  created_at        :datetime
#  updated_at        :datetime
#  label             :string(255)
#  protected         :boolean          default(FALSE)
#  hidden            :boolean          default(FALSE)
#  can_be_hidden     :boolean          default(TRUE)
#  default_value     :string(255)
#  half_width        :boolean          default(FALSE)
#

class TemplateField < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include ActivityLog

  has_superslug :title, :slug, :context => :template

  # ------------------------------------------ Associations

  belongs_to :template_group, :touch => true

  has_one :template, :through => :template_group
  has_one :site, :through => :template

  # ------------------------------------------ Scopes

  default_scope { order('position asc') }

  scope :alpha, -> { reorder('title asc') }

  # ------------------------------------------ Validations

  validates :title, :template_group, :data_type, :presence => true
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

  def group
    template_group
  end

  private

    def required_and_hidden
      if required? && hidden?
        errors.add(:hidden, "can't be required AND hidden")
      end
    end

end
