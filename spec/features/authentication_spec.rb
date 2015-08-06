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
        @user.site_users.destroy_all
        sign_in @user
        expect(page.current_path).to eq('/login')
      end
    end

    context 'has at least one site' do
      scenario 'User is redirected to first site when they login' do
        create(:site_user, :user => @user)
        sign_in @user
        expected_path = "/#{@user.first_site.uid}/editor/pages"
        expect(page.current_path).to eq(expected_path)
      end
    end
  end

end
