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

  describe 'content', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    context 'can be added to a page' do
      scenario 'with the save button' do
        within('table.pages') do
          first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
          sleep 0.35
          first('a.edit').click
        end
        within('.page-content') do
          fill_in('Subtitle', :with => 'This is my subtitle')
          click_button('Save')
          expect(page).to have_xpath("//input[@value='This is my subtitle']")
        end
      end
    end
  end

end
