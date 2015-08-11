# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  body       :text
#  ancestry   :string(255)
#  published  :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer          default(0)
#  page_path  :string(255)
#  site_id    :integer
#  field_data :json
#

require 'rails_helper'

describe Page, :type => :model do

  before :all do
    @published_page = create(:published_page)
    @draft_page = create(:draft_page)
  end

  context 'Unpublished page' do
    it 'is a draft if it is not published' do
      expect(@draft_page.draft?).to eq(true)
    end
    it 'has a draft status' do
      expect(@draft_page.status).to eq('draft')
    end
  end

  context 'Published page' do
    it 'is not a draft if it is published' do
      expect(@published_page.draft?).to eq(false)
    end
    it 'has a draft status' do
      expect(@published_page.status).to eq('published')
    end
  end

end
