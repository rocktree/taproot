# == Schema Information
#
# Table name: credentials
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  secret     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Credential, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
