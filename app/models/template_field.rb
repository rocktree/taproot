# == Schema Information
#
# Table name: template_fields
#
#  id          :integer          not null, primary key
#  template_id :integer
#  title       :string(255)
#  slug        :string(255)
#  data_type   :string(255)
#  options     :text
#  required    :boolean          default(FALSE)
#  position    :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

class TemplateField < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include FieldSlug

  # ------------------------------------------ Associations

  belongs_to :template, :touch => true

  has_one :site, :through => :template

  # ------------------------------------------ Scopes

  default_scope { order('position asc') }

  # ------------------------------------------ Instance Methods

  def option_values
    options.gsub(/\r/, '').split("\n") unless options.blank?
  end

end
