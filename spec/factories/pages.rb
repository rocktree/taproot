# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  body          :text
#  ancestry      :string(255)
#  published     :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#  page_path     :string(255)
#  site_id       :integer
#  field_data    :json
#  template_name :string(255)
#  meta          :json
#

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.words(4).join(' ') }
    template_name { Faker::Lorem.word }
    site

    factory :published_page do
      published true
    end
    factory :draft_page do
      published false
    end
    factory :page_w_parent do
      parent_id ''
    end
  end

end
