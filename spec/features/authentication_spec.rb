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
      before :all do
        create(:site_user, :user => @user)
      end
      scenario 'User is redirected to first site when they login' do
        sign_in @user
        expected_path = "/#{@user.first_site.uid}/editor/pages"
        expect(page.current_path).to eq(expected_path)
      end
      scenario 'User can login via a link in the header' do
        sign_in @user
        sign_out
      end
    end
  end

end
