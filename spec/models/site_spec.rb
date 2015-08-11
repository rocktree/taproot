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

describe Site, :type => :model do

  before :all do
    @site = create(:site)
  end

end
