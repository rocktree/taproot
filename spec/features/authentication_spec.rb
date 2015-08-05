require 'rails_helper'

feature 'Authentication' do

  before :all do
    @user = create(:user, :password => 'password')
  end

  context 'Unauthenticated user' do
    scenario 'can see login form' do
      visit root_path
      expect(page).to have_css('form#new_user')
    end
  end

  context 'Authenticated User' do
    context 'has no sites' do
      scenario 'is signed out of the application after they login' do
        puts page.current_path
        sign_in @user
        puts page.current_path
        # puts page.methods.collect(&:to_s).sort
      end
    end

    context 'has at least one site' do
      scenario 'User is redirected to first site when they login'
    end
  end

end
