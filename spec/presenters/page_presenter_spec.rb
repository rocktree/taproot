require 'rails_helper'

describe Page, :type => :model do

  before :all do
    @published_page = create(:published_page)
    @draft_page = create(:draft_page)
  end

  context 'Unpublished page' do
    it 'has a draft status' do
      expect(@draft_page.p.status).to eq('draft')
    end
    it 'uses the correct status icon' do
      exp_icon = "<i class=\"icon-draft color-dark-lightest\"></i>".html_safe
      expect(@draft_page.p.status_icon).to eq(exp_icon)
    end
  end

  context 'Published page' do
    it 'has a draft status' do
      expect(@published_page.p.status).to eq('published')
    end
    it 'uses the correct status icon' do
      exp_icon = "<i class=\"icon-checkmark color-success\"></i>".html_safe
      expect(@published_page.p.status_icon).to eq(exp_icon)
    end
  end

end
