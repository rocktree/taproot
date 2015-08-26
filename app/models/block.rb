# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  parent_id  :integer
#  page_id    :integer
#  position   :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Block < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :parents, :class_name => 'Page'
  belongs_to :page

  # ------------------------------------------ Scopes

  scope :in_position, -> { order('position asc') }

end
