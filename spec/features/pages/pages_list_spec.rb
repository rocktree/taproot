require 'rails_helper'

feature 'Pages List' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
  end

  scenario 'show the root pages title'
  scenario 'list the root page titles'
  scenario 'shows the last modified date'
  scenario 'drill down to a pages children if it has children'
  scenario 'not drill down to a pages children if it does not have any'
  scenario 'show the appropriate title when viewing children'
  scenario 'show the status of a published page'
  scenario 'show the status of a draft page'
  scenario 'launch the edit form'
  scenario 'publish a page in draft mode'
  scenario 'unpublish a published page'
  scenario 'show the warning message before deleting a page'
  scenario 'delete a page'

  # describe 'Route Hacking' do
  #   before :each do
  #     sign_in @user
  #   end
  #   scenario 'should redirect HTTP requests' do
  #     visit new_site_editor_page_path(@site, :t => 'home')
  #     expect(current_path).to eq(site_editor_pages_path(@site))
  #   end
  # end

  # describe 'New Page Form', :js => true do
  #   before :each do
  #     sign_in @user
  #     visit site_editor_path(@site)
  #     click_link('NEW')
  #     click_link('Home')
  #   end
  #   scenario 'shows a new page modal' do
  #     expect(page).to have_content('New Page')
  #   end
  #   scenario 'shows the template name' do
  #     expect(page).to have_content('Template: Home')
  #   end
  #   scenario 'redirects to edit form after creating page' do
  #     title = Faker::Lorem.words(5).join(' ')
  #     fill_in 'Title', :with => title
  #     click_button 'Next'
  #     wait_for_ajax
  #     page = @site.pages.find_by_title(title)
  #     expect(current_path).to eq(edit_site_editor_page_path(@site, page))
  #   end
  #   scenario 'requires a title to save the page' do
  #     click_button 'Next'
  #     expect(current_path).to eq(site_editor_pages_path(@site))
  #   end
  #   scenario 'can cancel a new page by closing the modal' do
  #     find("body").native.send_key(:escape)
  #     expect(page).to_not have_content('Template: Home')
  #   end
  # end

end
