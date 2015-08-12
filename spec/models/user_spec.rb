# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  settings               :text
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
#  api_key                :string(255)
#

require 'rails_helper'

describe User, :type => :model do

  before :all do
    @user = create(:user)
    create_list(:site, 5)
    create_list(:site_user, 4, :user => @user)
  end

  it 'has a 32-character API key' do
    expect(@user.api_key.size).to eq(32)
  end

  it 'is only associated to their sites' do
    expect(@user.sites.size).to eq(4)
  end
  it 'defaults to the first associated site' do
    site = @user.sites.order(:title => :asc).first
    expect(@user.first_site).to eq(site)
  end
  it 'has sites if it has been granted access' do
    expect(@user.has_sites?).to eq(true)
  end
  it 'does not have sites, even when sites exist, if it has not been given access' do
    create(:site)
    expect(create(:user).has_sites?).to eq(false)
  end
  it 'has multiple sites if it has been granted access to more than one site' do
    expect(@user.has_multiple_sites?).to eq(true)
  end
  it 'does not have multiple sites if it does not have access to more than one site' do
    user = create(:user)
    create(:site_user, :user => user)
    expect(user.has_multiple_sites?).to eq(false)
  end

end
