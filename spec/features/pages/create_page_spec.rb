require 'rails_helper'

feature 'Create New Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
  end

  describe 'Route Hacking' do
    before :each do
      sign_in @user
    end
    scenario 'should redirect HTTP requests' do
      visit new_site_editor_page_path(@site, :t => 'home')
      expect(current_path).to eq(site_editor_pages_path(@site))
    end
  end

  describe 'New Page Button', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
      click_link('NEW')
    end
    scenario 'has a new page link for each non-block template' do
      template_hrefs = @site.templates.all
        .reject { |t| t.block? }
        .collect { |t| "#{@site.uid}/editor/pages/new?t=#{t.name}"}
        .sort
      hrefs = []
      page.all('#new-button-container ul li a').each do |link|
        href = link[:href].split('//').last.split('/')[1..-1].join('/')
        hrefs << href
      end
      expect(hrefs.sort).to eq(template_hrefs)
    end
  end

  describe 'New Page Form', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
      click_link('NEW')
      click_link('Home')
    end
    scenario 'shows a new page modal with the template name' do
      expect(page).to have_content('New Home')
    end
    scenario 'redirects to edit form after creating page' do
      title = Faker::Lorem.words(5).join(' ')
      fill_in 'Title', :with => title
      click_button 'Next'
      wait_for_ajax
      page = @site.pages.find_by_title(title)
      expect(current_path).to eq(edit_site_editor_page_path(@site, page))
    end
    scenario 'requires a title to save the page' do
      click_button 'Next'
      expect(current_path).to eq(site_editor_pages_path(@site))
    end
    scenario 'can cancel a new page by closing the modal' do
      find("body").native.send_key(:escape)
      expect(page).to_not have_content('Template: Home')
    end
  end

end
