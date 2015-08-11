# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  settings               :text
#  admin                  :boolean          default(FALSE)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  fb_access_token        :string(255)
#  fb_token_expires       :datetime
#  api_key                :string(255)
#

require 'rails_helper'

describe Page, :type => :model do

  before :all do
    @published_page = create(:published_page)
    @draft_page = create(:draft_page)
  end

  context 'Unpublished page' do
    it 'has a draft status' do
      expect(@draft_page.p.status).to eq('draft')
    end
  end

  context 'Published page' do
    it 'has a draft status' do
      expect(@published_page.p.status).to eq('published')
    end
  end

end
