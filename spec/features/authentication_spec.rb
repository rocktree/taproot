require 'rails_helper'

feature 'Authentication' do

  scenario 'Unauthenticated user can see login form' do
    visit root_path
    expect(page).to have_css('form#new_user')
  end

end
