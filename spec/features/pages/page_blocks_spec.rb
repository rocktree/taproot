require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @feature = create(:page, :template_name => 'feature', :site => @site)
    @home = create(:page, :template_name => 'home', :site => @site)
    @about = create(:page, :template_name => 'about', :site => @site)
  end

  describe 'blocks', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'are not shown on templates without them' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@home.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      expect(page).to_not have_css('div.block')
    end
    scenario 'can undergo the proper CRUD cycle' do
      # Get to edit form
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@about.id}']").hover
        sleep 0.35
        first('a.edit').click
      end
      expect(page).to have_css('div.block')
      # Click to create a new block
      click_link 'Create New Feature Slide'
      wait_for_ajax
      within('.modal') do
        fill_in 'Title', :with => 'Hello World'
        click_button 'Next'
        wait_for_ajax
      end
      # Should be on the edit form for the new block
      fill_in 'La-dee La-dee Dah', :with => 'I am really really cool.'
      click_button 'Save'
      # Should be back on the edit for for the about page
      within('.page-content div.block') do
        expect(page).to have_content('Hello World')
      end
      # Editing the block
      within('.page-content div.block') do
        first('li.item').hover
        sleep 0.35
        first('a.edit').click
      end
      # This proves that the block attributes are being saved, so we don't have
      # to check again.
      expect(page).to have_xpath("//input[@value='I am really really cool.']")
      fill_in 'La-dee La-dee Dah', :with => 'I love turtles'
      click_button 'Save'
      within('.page-content div.block') do
        expect(page).to have_content('Hello World')
      end
      # Deleting a block
      within('.page-content div.block') do
        first('li.item').hover
        sleep 0.35
        first('a.delete').click
        page.driver.browser.switch_to.alert.accept
      end
      visit current_path
      within('.page-content div.block') do
        expect(page).to_not have_content('Hello World')
      end
      # Adding an existing block
      within('.page-content div.block') do
        click_link 'Add Existing Feature Slide'
        wait_for_ajax
      end
      within('.modal') { click_button 'Hello World' }
      within('.page-content div.block') do
        expect(page).to have_content('Hello World')
      end
      # Add another
      within('.page-content div.block') do
        click_link 'Add Existing Feature Slide'
        wait_for_ajax
      end
      within('.modal') { click_button @feature.title }
      # Reorder
      within('.page-content div.block') do
        @last_title = all('li.item span.title').last.text
        draggable = all('li.item .ui-sortable-handle')[1]
        droppable = first('li.item')
        draggable.drag_to(droppable)
        wait_for_ajax
      end
      visit current_path
      within('.page-content div.block') do
        new_title = all('li.item span.title').first.text
        expect(new_title).to eq(@last_title)
      end
    end
  end

end
