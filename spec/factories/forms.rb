# == Schema Information
#
# Table name: forms
#
#  id                  :integer          not null, primary key
#  site_id             :integer
#  title               :string(255)
#  slug                :string(255)
#  description         :text
#  body                :text
#  thank_you_body      :text
#  notification_emails :text
#  created_at          :datetime
#  updated_at          :datetime
#  key                 :string(255)
#  button_label        :string(255)
#  email_subject       :string(255)
#  email_body          :text
#  email_to_id         :integer
#

FactoryGirl.define do
  factory :form do
    site
    title { Faker::Lorem.word }
    slug "MyString"
    description "MyText"
    body "MyText"
    thank_you_body "MyText"
    notification_emails "MyText"
  end

end
