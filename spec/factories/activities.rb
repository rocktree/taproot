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
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :activity do
    item_type "MyString"
item_id 1
item_path "MyString"
site_id 1
  end

end
