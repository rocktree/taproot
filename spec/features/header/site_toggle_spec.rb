require 'rails_helper'

feature 'Site Toggle' do

  before :all do
    @user = create(:user, :password => 'password')
    @site = create(:site)
    create(:site_user, :site => @site, :user => @user)
    create_list(:site_user, 4, :user => @user)
    create_list(:site, 5)
  end

  before :each do
    sign_in @user
    visit site_editor_path(@site)
  end

  describe 'Site dropdown menu', :js => true do
    before :each do
      @trigger = page.find('.site-toggle .dropdown-trigger')
      @trigger.click
    end
    scenario 'has a list of sites in alphabetical order, minus the current site' do
      titles = (@user.sites.alpha - [@site]).collect(&:title)
      content = []
      page.all('.site-toggle ul li a').each { |link| content << link.text }
      expect(content.sort).to eq(titles)
    end
    scenario 'has a trigger with the name of the current site' do
      expect(@trigger.text).to eq(@site.title)
    end
    scenario 'provides working links to other sites' do
      page.all('.site-toggle ul li a')[1].click
      expected_path = "/#{(@user.sites.alpha - [@site])[1].uid}/editor/pages"
      expect(page.current_path).to eq(expected_path)
    end
  end

  describe 'No dropdown menu (only one site)', :js => true do
    before :all do
      @user = create(:user, :password => 'password')
      @site = create(:site)
      create(:site_user, :site => @site, :user => @user)
    end
    scenario 'is not a dropdown menu if there is only one site' do
      expect(page.all('.site-toggle.dropdown').size).to eq(0)
    end
    scenario 'does not have a dropdown trigger if there is only one site' do
      expect(page.all('.site-toggle .dropdown-trigger').size).to eq(0)
    end
  end

end
