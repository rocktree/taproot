require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)

    # Create a few pages
    @block_page = create(:page, :template_name => 'feature', :site => @site)
    @root_page = create(:page, :template_name => 'home', :site => @site,
                        :position => 1)
    @parent_page = create(:page, :template_name => 'home', :site => @site,
                          :position => 1)
    @page_1 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @parent_page.id)
    @page_2 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @parent_page.id)
    @page_3 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @parent_page.id)
    @page_4 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @parent_page.id)
  end

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'redirects root pages to site pages list' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@root_page.id}']").hover
        sleep 0.35
        first('a.delete').click
        page.driver.browser.switch_to.alert.accept
      end
      expect(current_path).to eq(site_editor_pages_path(@site))
      expect(page).to_not have_content(@root_page.title)
    end
    scenario 'can be deleted from pages list' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page_1.id}']").hover
        sleep 0.35
        first('a.delete').click
        page.driver.browser.switch_to.alert.accept
      end
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      expect(page).to_not have_content(@page_1.title)
    end
    scenario 'can be deleted from header on pages list' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page_2.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('.page-header') { first('a.delete').click }
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      expect(page).to_not have_content(@page_2.title)
    end
    scenario 'can be deleted from header on content form' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page_3.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      click_link('Content')
      within('.page-header') { first('a.delete').click }
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      expect(page).to_not have_content(@page_3.title)
    end
    scenario 'can be deleted from header on the meta form' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page_4.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      click_link('Meta')
      within('.page-header') { first('a.delete').click }
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      expect(page).to_not have_content(@page_4.title)
    end
  end

end
