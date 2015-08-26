# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  block_id   :integer
#  page_id    :integer
#  position   :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#

class Block < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :page
  belongs_to :block, :class_name => 'Page'

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }

  # ------------------------------------------ Validations

  validates :title, :block_id, :page_id, :presence => true

end
