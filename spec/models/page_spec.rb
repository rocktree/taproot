# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  body          :text
#  ancestry      :string(255)
#  published     :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#  page_path     :string(255)
#  site_id       :integer
#  field_data    :json
#  template_name :string(255)
#  meta          :json
#  field_search  :text
#

<<<<<<< HEAD
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  body          :text
#  ancestry      :string(255)
#  published     :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#  page_path     :string(255)
#  site_id       :integer
#  field_data    :json
#  template_name :string(255)
#  meta          :json
#  field_search  :text
=======
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
>>>>>>> get page specs rolling
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
  end

  context 'Published page' do
    it 'is not a draft if it is published' do
      expect(@published_page.draft?).to eq(false)
    end
  end

end
