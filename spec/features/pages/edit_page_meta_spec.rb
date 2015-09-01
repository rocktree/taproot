require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @page = create(:page, :template_name => 'home', :site => @site,
                   :position => 1)
  end

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'has a working meta form' do
      # Go to edit form
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      # Go to meta form
      click_link('Meta')
      # Change the description
      fill_in('Description', :with => 'I am not a robot.')
      click_button 'Update Page'
      # Check output
      expect(page).to have_xpath("//input[@value='I am not a robot.']")
      expect(current_path).to eq(site_editor_page_meta_path(@site, @page))
    end
  end

end
