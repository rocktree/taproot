require 'rails_helper'

feature 'New button' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
  end

  describe 'dropdown menu', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
      @trigger = page.find('#new-button-container .dropdown-trigger')
    end
    scenario 'is not visible without clicking "New"' do
      expect(page).to_not have_css('#new-button-container ul li a')
    end
    scenario 'hides if "New" is clicked twice (toggled)' do
      @trigger.click
      @trigger.click
      expect(page).to_not have_css('#new-button-container ul li a')
    end
  end

end
