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
    @parent_page = create(:page, :template_name => 'home', :site => @site,
                          :position => 1)
    @page = create(:page, :template_name => 'home', :site => @site,
                   :parent_id => @parent_page.id)
  end

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    # This goes through the entire publishing and unpublishing process
    # This also checks that we redirect to the correct page
    scenario 'can be published from pages list' do
      # Drill down to child page
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      # Click publish
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.publish').click
      end
      # We're on the parent's page
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      # We show the child page as being published
      within('tbody tr:nth-child(1)') do
        expect(page).to have_content(@page.title)
        expect(all('td.status-icon > .icon-publish').size).to eq(1)
      end
      # Click unpublish
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.unpublish').click
      end
      # We're still on the parent's page
      expect(current_path).to eq(site_editor_page_path(@site, @parent_page))
      # We show the child page as being in draft mode
      within('tbody tr:nth-child(1)') do
        expect(page).to have_content(@page.title)
        expect(all('td.status-icon > .icon-draft').size).to eq(1)
      end
    end
    scenario 'can be published from child pages list' do
      # Drill down to child page
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@parent_page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      # --------------------------
      # From the child pages
      # --------------------------
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      # Click publish
      within('.page-header') do
        first('a.publish').click
      end
      # We're on the same path
      expect(current_path).to eq(site_editor_page_path(@site, @page))
      # Check for status designation
      within('.page-header') { expect(page).to have_content('Published') }
      # Click unpublish
      within('.page-header') { first('a.unpublish').click }
      # We're on the same path
      expect(current_path).to eq(site_editor_page_path(@site, @page))
      # Check for status designation
      within('.page-header') { expect(page).to have_content('Status: Draft') }
      # --------------------------
      # From the meta form
      # --------------------------
      click_link 'Meta'
      within('.page-header') { first('a.publish').click }
      expect(current_path).to eq(site_editor_page_meta_path(@site, @page))
      within('.page-header') { expect(page).to have_content('Published') }
      within('.page-header') { first('a.unpublish').click }
      expect(current_path).to eq(site_editor_page_meta_path(@site, @page))
      within('.page-header') { expect(page).to have_content('Status: Draft') }
      # --------------------------
      # Content form
      # --------------------------
      click_link 'Content'
      within('.page-header') { first('a.publish').click }
      expect(current_path).to eq(edit_site_editor_page_path(@site, @page))
      within('.page-header') { expect(page).to have_content('Published') }
      within('.page-header') { first('a.unpublish').click }
      expect(current_path).to eq(edit_site_editor_page_path(@site, @page))
      within('.page-header') { expect(page).to have_content('Status: Draft') }
    end
  end

end
