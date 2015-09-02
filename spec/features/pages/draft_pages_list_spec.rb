require 'rails_helper'

feature 'Draft Pages' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)

    # Create a few pages
    @block_1 = create(:page, :template_name => 'feature', :site => @site)
    @block_2 = create(:page, :template_name => 'feature', :site => @site)
    @draft_1 = create(:page, :template_name => 'about', :site => @site)
    @draft_2 = create(:page, :template_name => 'about', :site => @site)
    @published_1 = create(:published_page, :template_name => 'home',
                          :site => @site)
    @published_2 = create(:published_page, :template_name => 'home',
                          :site => @site)
  end

  describe 'list', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'shows only current drafts' do
      within('#sidebar') { click_link('Drafts') }
      within('.page-content') do
        expect(page).to have_content(@draft_1.title)
        expect(page).to have_content(@draft_2.title)
        expect(page).to_not have_content(@block_1.title)
        expect(page).to_not have_content(@block_2.title)
        expect(page).to_not have_content(@published_1.title)
        expect(page).to_not have_content(@published_2.title)
      end
    end
  end

end
