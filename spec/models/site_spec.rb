# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  git_url    :string(255)
#  uid        :string(255)
#  config     :json
#  templates  :json
#

require 'rails_helper'

describe Site, :type => :model do

  before :all do
    @site = create(:site)
  end

  it 'generates and self-assigns a UID when created' do
    expect(@site.uid.size).to eq(18)
  end

end
