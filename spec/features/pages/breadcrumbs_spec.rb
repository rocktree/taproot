require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @page = create(:published_page, :template_name => 'home', :site => @site,
                   :position => 1)
    @page_1 = create(:page, :template_name => 'home', :site => @site,
                     :position => 2)
    @page_2 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_1.id)
    @page_3 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_2.id)
    @page_4 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_3.id)
    @page_5 = create(:page, :template_name => 'home', :site => @site,
                     :parent_id => @page_4.id)
  end

  describe 'breadcrumbs' do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'are all present and clickable' do
      visit site_editor_page_path(@site, @page_5)
      within('.page-header .breadcrumbs') do
        expect(page).to have_content('Site Pages')
        expect(page).to have_content(@page_1.title)
        expect(page).to have_content(@page_2.title)
        expect(page).to have_content(@page_3.title)
        expect(page).to have_content(@page_4.title)
        expect(page).to_not have_content(@page_5.title)
        click_link(@page_4.title)
      end
      within('.page-header .breadcrumbs') do
        expect(page).to have_content('Site Pages')
        expect(page).to have_content(@page_1.title)
        expect(page).to have_content(@page_2.title)
        expect(page).to have_content(@page_3.title)
        expect(page).to_not have_content(@page_4.title)
        expect(page).to_not have_content(@page_5.title)
        click_link(@page_3.title)
      end
      within('.page-header .breadcrumbs') do
        expect(page).to have_content('Site Pages')
        expect(page).to have_content(@page_1.title)
        expect(page).to have_content(@page_2.title)
        expect(page).to_not have_content(@page_3.title)
        expect(page).to_not have_content(@page_4.title)
        expect(page).to_not have_content(@page_5.title)
        click_link(@page_2.title)
      end
      within('.page-header .breadcrumbs') do
        expect(page).to have_content('Site Pages')
        expect(page).to have_content(@page_1.title)
        expect(page).to_not have_content(@page_2.title)
        expect(page).to_not have_content(@page_3.title)
        expect(page).to_not have_content(@page_4.title)
        expect(page).to_not have_content(@page_5.title)
        click_link(@page_1.title)
      end
      within('.page-header .breadcrumbs') do
        expect(page).to have_content('Site Pages')
        click_link('Site Pages')
      end
      expect(current_path).to eq(site_editor_pages_path(@site))
    end
  end

end
