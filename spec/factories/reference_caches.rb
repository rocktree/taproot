# == Schema Information
#
# Table name: reference_caches
#
#  id         :integer          not null, primary key
#  item_type  :string(255)
#  item_id    :integer
#  site_title :string(255)
#  site_path  :string(255)
#  item_path  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :reference_cach, :class => 'ReferenceCache' do
    item_type "MyString"
item_id 1
site_title "MyString"
site_path "MyString"
item_path "MyString"
  end

end
