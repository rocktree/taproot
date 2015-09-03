require 'rails_helper'

describe User, :type => :model do

  before :all do
    @user = create(:user)
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
