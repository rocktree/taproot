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
  end

  context 'Published page' do
    it 'has a draft status' do
      expect(@published_page.p.status).to eq('published')
    end
  end

end
