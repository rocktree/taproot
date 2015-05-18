# == Schema Information
#
# Table name: form_fields
#
#  id            :integer          not null, primary key
#  form_id       :integer
#  title         :string(255)
#  data_type     :string(255)
#  options       :text
#  required      :boolean          default(FALSE)
#  position      :integer          default(0)
#  created_at    :datetime
#  updated_at    :datetime
#  slug          :string(255)
#  label         :string(255)
#  placeholder   :string(255)
#  default_value :string(255)
#  show_label    :boolean          default(TRUE)
#  hidden        :boolean          default(FALSE)
#

class FormField < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include FormSlug

  has_paper_trail

  # ------------------------------------------ Associations

  belongs_to :form, :touch => true

  has_one :site, :through => :form

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }
  scope :visible, -> { where(:hidden => false) }

  # ------------------------------------------ Validations

  validates :title, :data_type, :presence => true

  # ------------------------------------------ Callbacks

  after_validation :check_empty_label

  def check_empty_label
    if title.present? && label.blank?
      self.label = title
    end
  end

  # ------------------------------------------ Instance Methods

  def option_values
    options.split("\n").reject(&:blank?)
  end

end
