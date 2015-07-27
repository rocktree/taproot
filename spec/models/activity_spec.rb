# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  item_type  :string(255)
#  item_id    :integer
#  item_path  :string(255)
#  site_id    :integer
#  user_id    :integer
#  action     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Activity, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
