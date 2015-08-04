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

RSpec.describe User, :type => :model do

  before :all do
    @user = FactoryGirl.create(:user)
    @admin_user = FactoryGirl.create(:admin_user)
  end

  it 'is a site user if it is not an admin' do
    expect(@user.site_user?).to eq(true)
  end

  it 'is not a site user if it is an admin' do
    expect(@admin_user.site_user?).to eq(false)
  end

end
