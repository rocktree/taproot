# == Schema Information
#
# Table name: reference_caches
#
#  id         :integer          not null, primary key
#  item_type  :string(255)
#  item_id    :integer
#  site_title :string(255)
#  site_path  :string(255)
#  item_path  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe ReferenceCache, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
