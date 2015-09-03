require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @page_1 = create(:page, :template_name => 'home', :site => @site,
                     :position => 1)
    @page_2 = create(:page, :template_name => 'home', :site => @site,
                     :position => 2)
    @page_3 = create(:page, :template_name => 'home', :site => @site,
                     :position => 3)
    @page_4 = create(:page, :template_name => 'home', :site => @site,
                     :position => 4)
    @page_5 = create(:page, :template_name => 'home', :site => @site,
                     :position => 5)
  end

  describe 'move mode', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'does not work if not in move mode' do
      within('table.pages') do
        page_2 = first(:xpath, "//tr[@data-page-id='#{@page_2.id}']")
        page_4 = first(:xpath, "//tr[@data-page-id='#{@page_4.id}']")
        page_4.drag_to(page_2)
      end
      visit current_path
      within('table.pages tbody') do
        expect(page).to have_content(@page_4.title)
      end
    end
    scenario 'will nest pages when in move mode' do
      within('.page-header') { first('a.nest').click }
      within('table.pages') do
        page_2 = first(:xpath, "//tr[@data-page-id='#{@page_2.id}']")
        page_4 = first(:xpath, "//tr[@data-page-id='#{@page_4.id}']")
        page_4.drag_to(page_2)
      end
      wait_for_ajax
      visit current_path
      within('table.pages') do
        expect(page).to_not have_content(@page_4.title)
        first(:xpath, "//tr[@data-page-id='#{@page_2.id}']").hover
        sleep 0.35
        first('a.right').click
        expect(page).to have_content(@page_4.title)
      end
    end
    scenario 'can move back up the tree by dropping on sidebar' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page_2.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('.page-header') { first('a.nest').click }
      within('#sidebar') { click_link('pages-subnav-trigger') }
      page_5 = all('#sidebar a.droppable').last
      page_4 = first(:xpath, "//tr[@data-page-id='#{@page_4.id}']")
        .find('td:last-child')
      page_4.drag_to(page_5)
      wait_for_ajax
      within('#sidebar') { all('#sidebar a.droppable').last.click }
      within('table.pages') do
        expect(page).to have_content(@page_4.title)
      end
    end
  end

end
