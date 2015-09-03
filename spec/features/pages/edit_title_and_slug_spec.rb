require 'rails_helper'

feature 'Page' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
    @page = create(:page, :template_name => 'home', :site => @site)
  end

  describe 'title and slug', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    context 'can be edited on all current pages' do
      scenario 'with the save button' do
        # Drill down to child page
        within('table.pages') do
          first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
          sleep 0.35
          first('a.right').click
        end
        # Child pages
        within('.page-header') do
          expect(page).to_not have_css('a.save-page')
          first('h1 span.title').set('First Title')
          first('h1 span.slug').set(' first-title-123')
          first('a.save-page').click
          @page.reload
          expect(current_path).to eq(site_editor_page_path(@site, @page))
          expect(page).to have_content('First Title')
          expect(page).to have_content('first-title-123')
        end
        # Content form
        click_link 'Content'
        within('.page-header') do
          expect(page).to_not have_css('a.save-page')
          first('h1 span.title').set('Second Title')
          first('h1 span.slug').set(' second-title-123')
          first('a.save-page').click
          @page.reload
          expect(current_path).to eq(edit_site_editor_page_path(@site, @page))
          expect(page).to have_content('Second Title')
          expect(page).to have_content('second-title-123')
        end
        # Meta form
        click_link 'Meta'
        within('.page-header') do
          expect(page).to_not have_css('a.save-page')
          first('h1 span.title').set('Third Title')
          first('h1 span.slug').set(' third-title-123')
          first('a.save-page').click
          @page.reload
          expect(current_path).to eq(site_editor_page_meta_path(@site, @page))
          expect(page).to have_content('Third Title')
          expect(page).to have_content('third-title-123')
        end
      end
      scenario 'by hitting enter' do
        # Drill down to child page
        within('table.pages') do
          first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
          sleep 0.35
          first('a.right').click
        end
        # Child pages
        within('.page-header') do
          title = first('h1 span.title')
          title.set('First Title')
          title.native.send_keys(:return)
          slug = first('h1 span.slug')
          slug.set('first-title-123')
          slug.native.send_keys(:return)
          visit current_path
          expect(page).to have_content('First Title')
          expect(page).to have_content('first-title-123')
        end
        # Content form
        click_link 'Content'
        within('.page-header') do
          title = first('h1 span.title')
          title.set('Second Title')
          title.native.send_keys(:return)
          slug = first('h1 span.slug')
          slug.set('second-title-123')
          slug.native.send_keys(:return)
          visit current_path
          expect(page).to have_content('Second Title')
          expect(page).to have_content('second-title-123')
        end
        # Meta form
        click_link 'Meta'
        within('.page-header') do
          title = first('h1 span.title')
          title.set('Third Title')
          title.native.send_keys(:return)
          slug = first('h1 span.slug')
          slug.set('third-title-123')
          slug.native.send_keys(:return)
          visit current_path
          expect(page).to have_content('Third Title')
          expect(page).to have_content('third-title-123')
        end
      end
    end
  end

  describe 'slug', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'will be auto-populated if left blank' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('.page-header') do
        first('h1 span.title').set('Hello World')
        first('h1 span.slug').set(' ')
        first('a.save-page').click
        expect(page).to have_content('hello-world')
      end
    end
  end

  describe 'title', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'can not be left blank' do
      within('table.pages') do
        first(:xpath, "//tr[@data-page-id='#{@page.id}']").hover
        sleep 0.35
        first('a.right').click
      end
      within('.page-header') do
        @page.reload
        first('h1 span.title').set(' ')
        first('a.save-page').click
        visit current_path
        expect(page).to have_content(@page.title)
      end
    end
  end

end
