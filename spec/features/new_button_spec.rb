require 'rails_helper'

feature 'New button' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    create(:site_user, :site => @site, :user => @user)
  end

  describe 'dropdown menu', :js => true do
    before :each do
      sign_in @user
      visit site_editor_path(@site)
      @trigger = page.find('#new-button-container .dropdown-trigger')
    end
    scenario 'is not visible without clicking "New"' do
      expect(page).to_not have_css('#new-button-container ul li a')
    end
    scenario 'is visible when clicking "New"' do
      @trigger.click
      expect(page).to have_css('#new-button-container ul li a')
    end
    scenario 'hides if "New" is clicked twice (toggled)' do
      @trigger.click
      @trigger.click
      expect(page).to_not have_css('#new-button-container ul li a')
    end
    scenario 'has a new page link for each template' do
      template_hrefs = @site.templates.all
        .collect { |t| "#{@site.uid}/editor/pages/new?t=#{t.name}"}.sort
      hrefs = []
      @trigger.click
      page.all('#new-button-container ul li a').each do |link|
        href = link[:href].split('//').last.split('/')[1..-1].join('/')
        hrefs << href
      end
      expect(hrefs.sort).to eq(template_hrefs)
    end
  end

end
