require 'rails_helper'

feature 'Sitemap Navigation' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)

    # Create a few pages
    @page = create(:page, :template_name => 'home', :site => @site)
    @page_1 = create(:page, :template_name => 'home', :site => @site)
    @page_2 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_1.id)
    @page_3 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_2.id)
    @page_4 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_3.id)
    @page_5 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_4.id)
    @block_page = create(:page, :template_name => 'feature', :site => @site)
  end

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
    end
    # This tests the presence and absence of pages as we drill down
    scenario 'drills down at least five levels and drills back up' do
      within('#sidebar') do
        # Normal state
        expect(page).to_not have_content(@page.title)
        expect(page).to_not have_content(@page_1.title)
        # Expand
        click_link('pages-subnav-trigger')
        expect(page).to have_content(@page.title)
        expect(page).to have_content(@page_1.title)
        expect(page).to_not have_content(@page_2.title)
        first(:css, '.pages-inlist-trigger.level-1').click
        expect(page).to have_content(@page_2.title)
        expect(page).to_not have_content(@page_3.title)
        first(:css, '.pages-inlist-trigger.level-2').click
        expect(page).to have_content(@page_3.title)
        expect(page).to_not have_content(@page_4.title)
        first(:css, '.pages-inlist-trigger.level-3').click
        expect(page).to have_content(@page_4.title)
        expect(page).to_not have_content(@page_5.title)
        first(:css, '.pages-inlist-trigger.level-4').click
        expect(page).to have_content(@page_5.title)
        # Collapse
        first(:css, '.pages-inlist-trigger.level-4').click
        expect(page).to_not have_content(@page_5.title)
        first(:css, '.pages-inlist-trigger.level-3').click
        expect(page).to_not have_content(@page_4.title)
        first(:css, '.pages-inlist-trigger.level-2').click
        expect(page).to_not have_content(@page_3.title)
        first(:css, '.pages-inlist-trigger.level-1').click
        expect(page).to_not have_content(@page_2.title)
        click_link('pages-subnav-trigger')
        expect(page).to_not have_content(@page_1.title)
      end
    end
    scenario 'does not have arrows when there are no children' do
      within('#sidebar') do
        click_link('pages-subnav-trigger')
        expect(all('ul.pages > li').size).to eq(2)
        expect(all('.pages-inlist-trigger.level-1').size).to eq(1)
      end
    end
    scenario 'does not show block-only pages' do
      within('#sidebar') do
        click_link('pages-subnav-trigger')
        expect(page).to_not have_content(@block_page.title)
      end
    end
    scenario 'goes to the child pages when clicking on the page title' do
      within('#sidebar') do
        click_link('pages-subnav-trigger')
        click_link(@page_1.title)
        expect(current_path).to eq(site_editor_page_path(@site, @page_1))
      end
    end
  end

end
