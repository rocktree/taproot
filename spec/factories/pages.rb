# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  body       :text
#  ancestry   :string(255)
#  published  :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer          default(0)
#  page_path  :string(255)
#  site_id    :integer
#  field_data :json
#

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.words(4).join(' ') }
    site

    factory :published_page do
      published true
    end
    factory :draft_page do
      published false
    end
  end

end
