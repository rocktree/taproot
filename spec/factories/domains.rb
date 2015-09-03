# == Schema Information
#
# Table name: domains
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  site_id     :integer
#  redirect_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :domain do
    title "MyString"
site_id 1
redirect_id 1
  end

end
