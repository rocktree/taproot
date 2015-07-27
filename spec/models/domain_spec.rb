# == Schema Information
#
# Table name: domains
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  site_id     :integer
#  redirect_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Domain, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
