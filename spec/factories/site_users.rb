# == Schema Information
#
# Table name: site_users
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :site_user do
    site
    user
  end

end
