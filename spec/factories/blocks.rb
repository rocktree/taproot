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
#  title      :string(255)
#

FactoryGirl.define do
  factory :block do
    parent_id 1
page_id 1
position 1
  end

end
