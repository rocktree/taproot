# == Schema Information
#
# Table name: form_submissions
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  idx        :integer          default(0)
#  field_data :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe FormSubmission, :type => :model do

  # describe '.send_notification' do

  #   context 'with no notification_emails' do
  #     it 'sends no emails' do
  #       form = create(:form, :notification_emails => nil)
  #       form_submission = create(
  #         :form_submission,
  #         :form => form
  #       )
  #       expect{
  #         form_submission.send_notification
  #       }.to change(ActionMailer::Base.deliveries, :count).by(0)
  #     end
  #   end
  #   context 'with one notification_email' do
  #     it 'sends one email' do
  #       form = create(:form, :notification_emails => 'dinkus@me.org')
  #       form_submission = create(
  #         :form_submission,
  #         :form => form
  #       )
  #       form_submission.send_notification
  #       expect(ActionMailer::Base.deliveries.last.to.to_a.count).to eq(1)
  #     end
  #   end
  #   context 'with 2 notification_emails' do
  #     it 'sends two emails' do
  #       form = create(
  #         :form,
  #         :notification_emails => "dinkus@me.org\ndonkus@dingle.sexy")
  #       form_submission = create(
  #         :form_submission,
  #         :form => form
  #       )
  #       form_submission.send_notification
  #       expect(ActionMailer::Base.deliveries.last.to.to_a.count).to eq(2)
  #     end
  #   end
  #   context 'with subject-specific notification_emails' do

  #     before :each do
  #       @form = create(
  #         :form,
  #         :notification_emails => "dinkus@me.org|f|hello\ndonkus@dingle.sexy|f|goodbye"
  #       )
  #       @form_submission = create(
  #         :form_submission,
  #         :form => @form,
  #         :field_data => {'f' => 'hello'}
  #       )
  #     end

  #     it 'only sends to chosen subject' do
  #       @form_submission.send_notification
  #       expect(ActionMailer::Base.deliveries.last.to.to_a).to include(
  #         'dinkus@me.org'
  #       )
  #     end
  #     it 'does not send to unchosen subject' do |variable|
  #       @form_submission.send_notification
  #       expect(ActionMailer::Base.deliveries.last.to.to_a).to_not include(
  #         'donkus@dingle.sexy'
  #       )
  #     end
  #   end
  # end

end
