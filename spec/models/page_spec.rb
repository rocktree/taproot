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
#  api_key                :string(255)
#

require 'rails_helper'

describe Page, :type => :model do

  # before :all do
  #   @user = create(:user)
  #   @admin_user = create(:admin_user)
  # end

  # # ------------------------------------------ API

  # it 'has a 32-character API key' do
  #   expect(@user.api_key.size).to eq(32)
  # end

  # # ------------------------------------------ Site User

  # context 'without admin privileges' do
  #   before :all do
  #     create_list(:site, 5)
  #     create_list(:site_user, 4, :user => @user)
  #   end
  #   it 'is a site user' do
  #     expect(@user.site_user?).to eq(true)
  #   end
  #   it 'is only associated to their sites' do
  #     expect(@user.sites.size).to eq(4)
  #   end
  #   it 'defaults to the first associated site' do
  #     site = @user.site_user_sites.order(:title => :asc).first
  #     expect(@user.first_site).to eq(site)
  #   end
  #   it 'has sites if it has been granted access' do
  #     expect(@user.has_sites?).to eq(true)
  #   end
  #   it 'does not have sites, even when sites exist, if it has not been given access' do
  #     expect(create(:user).has_sites?).to eq(false)
  #   end
  #   it 'has multiple sites if it has been granted access to more than one site' do
  #     expect(@user.has_multiple_sites?).to eq(true)
  #   end
  #   it 'does not have multiple sites if it does not have access to more than one site' do
  #     user = create(:user)
  #     create(:site_user, :user => user)
  #     expect(user.has_multiple_sites?).to eq(false)
  #   end
  # end

  # # ------------------------------------------ Admin

  # context 'with admin privileges' do
  #   before :all do
  #     create_list(:site, 5)
  #   end
  #   it 'is not a site user' do
  #     expect(@admin_user.site_user?).to eq(false)
  #   end
  #   it 'is associated to all sites' do
  #     expect(@admin_user.sites.size).to eq(Site.all.size)
  #   end
  #   it 'defaults to the first site in the application' do
  #     expect(@admin_user.first_site).to eq(Site.alpha.first)
  #   end
  #   it 'has sites as long as a site exists' do
  #     create(:site)
  #     expect(@admin_user.has_sites?).to eq(true)
  #   end
  #   it 'does not have sites only if no sites exist' do
  #     Site.destroy_all
  #     expect(@admin_user.has_sites?).to eq(false)
  #     create_list(:site, 5)
  #   end
  #   it 'has multiple sites if more than one site exist' do
  #     create_list(:site, 2)
  #     expect(@admin_user.has_multiple_sites?).to eq(true)
  #   end
  #   it 'does not have multiple sites if only one sites exists' do
  #     Site.destroy_all
  #     create(:site)
  #     expect(@admin_user.has_multiple_sites?).to eq(false)
  #     create_list(:site, 5)
  #   end
  # end

end
