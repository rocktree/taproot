# == Schema Information
#
# Table name: sites
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  slug           :string(255)
#  url            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  home_page_id   :integer
#  git_url        :string(255)
#  secondary_urls :text
#  template_url   :string(255)
#

FactoryGirl.define do
  factory :site do
    title { Faker::Lorem.word }
    url { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
    git_url { Faker::Internet.url }
  end

end
