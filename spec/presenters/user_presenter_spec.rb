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

describe User, :type => :model do

  before :all do
    @user = create(:user)
    @admin_user = create(:admin_user)
  end

  context 'without a name' do
    before(:all) { @user = create(:user, :name => nil) }
    it 'returns an empty string for its first name' do
      expect(@user.p.first_name).to eq('')
    end
    it 'returns an empty string for its last name' do
      expect(@user.p.last_name).to eq('')
    end
    it 'returns the email address for its name' do
      expect(@user.p.name).to eq(@user.email)
    end
  end

  context 'with a name' do
    before(:all) { @user = create(:user, :name => 'John Smith') }
    it 'has a first name' do
      expect(@user.p.first_name).to eq('John')
    end
    it 'has a last name' do
      expect(@user.p.last_name).to eq('Smith')
    end
  end

  context 'with three names' do
    before(:all) { @user = create(:user, :name => 'John Louis Smith') }
    it 'has a first name' do
      expect(@user.p.first_name).to eq('John')
    end
    it 'has a last name' do
      expect(@user.p.last_name).to eq('Smith')
    end
  end

end
