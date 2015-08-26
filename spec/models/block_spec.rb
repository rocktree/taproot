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

require 'rails_helper'

RSpec.describe Block, :type => :model do
end
