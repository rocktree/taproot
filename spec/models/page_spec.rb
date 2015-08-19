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
#

require 'rails_helper'

describe Page, :type => :model do

  before :all do
    @site = create(:site)
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    @published_page = create(:published_page, :template_name => 'home')
    @draft_page = create(:draft_page, :template_name => 'home')
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

  context 'Template' do
    it 'should not be able to be saved without an existing template'
    it 'should retrieve a Template object via the `template` method'
  end

end
