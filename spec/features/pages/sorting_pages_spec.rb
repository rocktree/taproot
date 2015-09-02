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

  describe 'reordering', :js => true do
    before :each do
      sign_in @user
      visit site_editor_pages_path(@site)
    end
    scenario 'can not reorder when not in move mode' do
      within('table.pages') do
        page_1 = first(:xpath, "//tr[@data-page-id='#{@page_1.id}']")
        page_2 = first(:xpath, "//tr[@data-page-id='#{@page_2.id}']")
        page_3 = first(:xpath, "//tr[@data-page-id='#{@page_3.id}']")
        page_4 = first(:xpath, "//tr[@data-page-id='#{@page_4.id}']")
        page_5 = first(:xpath, "//tr[@data-page-id='#{@page_5.id}']")
        page_3.drag_to(page_1) # 3 1 2 4 5
        page_4.drag_to(page_2) # 3 1 4 2 5
        page_5.drag_to(page_1) # 3 5 1 4 2
      end
      within('.page-header') { expect(page).to_not have_css('a.save-order') }
      visit current_path
      within('table.pages tbody') do
        within('tr:nth-child(1)') do
          expect(page).to have_content(@page_1.title)
        end
        within('tr:nth-child(2)') do
          expect(page).to have_content(@page_2.title)
        end
        within('tr:nth-child(3)') do
          expect(page).to have_content(@page_3.title)
        end
        within('tr:nth-child(4)') do
          expect(page).to have_content(@page_4.title)
        end
        within('tr:nth-child(5)') do
          expect(page).to have_content(@page_5.title)
        end
      end
    end
    scenario 'can reorder items when in move mode' do
      within('.page-header') do
        expect(page).to_not have_css('a.save-order')
        first('a.reorder').click
      end
      within('table.pages') do
        page_1 = first(:xpath, "//tr[@data-page-id='#{@page_1.id}']")
        page_2 = first(:xpath, "//tr[@data-page-id='#{@page_2.id}']")
        page_3 = first(:xpath, "//tr[@data-page-id='#{@page_3.id}']")
        page_4 = first(:xpath, "//tr[@data-page-id='#{@page_4.id}']")
        page_5 = first(:xpath, "//tr[@data-page-id='#{@page_5.id}']")
        page_3.drag_to(page_1) # 3 1 2 4 5
        page_4.drag_to(page_2) # 3 1 4 2 5
        page_5.drag_to(page_1) # 3 5 1 4 2
      end
      within('.page-header') { first('a.save-order').click }
      within('table.pages tbody') do
        within('tr:nth-child(1)') do
          expect(page).to have_content(@page_3.title)
        end
        within('tr:nth-child(2)') do
          expect(page).to have_content(@page_5.title)
        end
        within('tr:nth-child(3)') do
          expect(page).to have_content(@page_1.title)
        end
        within('tr:nth-child(4)') do
          expect(page).to have_content(@page_4.title)
        end
        within('tr:nth-child(5)') do
          expect(page).to have_content(@page_2.title)
        end
      end
    end
  end

end
