require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @page = create(:page, :template_name => 'home', :site => @site)
  end

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'lists the template name' do
      # Drill down to child page
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      # Child pages
      within('.page-header') do
        expect(page).to have_content('Template: Home')
      end
      # Content form
      click_link 'Content'
      within('.page-header') do
        expect(page).to have_content('Template: Home')
      end
      # Meta form
      click_link 'Meta'
      within('.page-header') do
        expect(page).to have_content('Template: Home')
      end
    end
  end

end
