require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @home = create(:page, :template_name => 'home', :site => @site)
    @about = create(:page, :template_name => 'about', :site => @site)
  end

  describe 'WYSIWYG editor', :js => :true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'appears when it is mentioned in template fields' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@home.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      expect(page).to_not have_css('.page-content .page_body .trumbowyg')
      within('#sidebar') { click_link('Pages') }
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@about.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      expect(page).to have_css('.page-content .page_body .trumbowyg')
    end
    scenario 'saves content typed in it' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@about.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      within('div.page_body') do
        first('.trumbowyg-bold-button').click
        first('div.trumbowyg-editor').set('Hello World')
      end
      within('.page-content') { click_button('Save') }
      within('div.page_body') do
        first('.trumbowyg-viewHTML-button').click
        expect(page).to have_content('<b>Hello World<br></b>')
      end
    end
  end

end
