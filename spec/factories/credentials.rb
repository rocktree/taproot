# == Schema Information
#
# Table name: credentials
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  secret     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :credential do
    key "MyString"
secret "MyString"
  end

end
