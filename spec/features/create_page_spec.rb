require 'rails_helper'

feature 'Create New Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site, :title => "A#{Faker::Lorem.words(4).join(' ')}")
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
  end

  describe 'Route Hacking' do
    before :each do
      sign_in @user
    end
    scenario 'should redirect to index if there is no template in the URL' do
      visit new_site_editor_page_path(@site)
      expect(current_path).to eq(site_editor_pages_path(@site))
    end
    scenario 'should redirect to index if the template does not exist' do
      visit new_site_editor_page_path(@site, :t => 'wrong')
      expect(current_path).to eq(site_editor_pages_path(@site))
    end
  end

  describe 'New Page Form', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
      click_link('NEW')
      click_link('Home')
    end
    scenario 'shows the template name' do
      expect(page).to have_content('Template: Home')
    end
    scenario 'displays the page in draft mode' do
      expect(page).to have_content('Status: Draft')
    end
    scenario 'can create a new page'
    scenario 'requires a title to save the page' do
      click_button 'Next'
      expect(current_path).to eq(new_site_editor_page_path(@site))
    end
  end

end
