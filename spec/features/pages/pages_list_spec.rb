require 'rails_helper'

feature 'Pages List' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)

    # Create a few pages
    @block_page = create(:page, :template_name => 'feature', :site => @site)
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

  describe '', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'shows title, template, last updated of root pages' do
      # This also checks sort order
      within('tbody tr:nth-child(1)') do
        expect(page).to have_content(@page.title)
        expect(page).to have_content(@page.template.title)
        expect(page).to have_content(@page.updated_at.pretty)
        expect(all('td.status-icon > .icon-publish').size).to eq(1)
      end
      expect(page).to have_content(@page_1.title)
      expect(page).to have_content(@page_1.template.title)
      expect(page).to have_content(@page_1.updated_at.pretty)
      expect(all('td.status-icon > .icon-draft').size).to eq(1)
      # Doesn't show child pages
      expect(page).to_not have_content(@page_2.title)
      # Doesn't show block-only pages
      expect(page).to_not have_content(@block_page.title)
    end

    scenario 'can drill down at least five levels' do
      first(:xpath, "//tr[@data-page-id='#{@page_1.id}']").hover
      sleep 0.35
      first('a.right').click
      expect(page).to have_content(@page_2.title)
      first(:xpath, "//tr[@data-page-id='#{@page_2.id}']").hover
      sleep 0.35
      first('a.right').click
      expect(page).to have_content(@page_3.title)
      first(:xpath, "//tr[@data-page-id='#{@page_3.id}']").hover
      sleep 0.35
      first('a.right').click
      expect(page).to have_content(@page_4.title)
      first(:xpath, "//tr[@data-page-id='#{@page_4.id}']").hover
      sleep 0.35
      first('a.right').click
      expect(page).to have_content(@page_5.title)
    end
  end

end
