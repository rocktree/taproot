# == Schema Information
#
# Table name: site_users
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class SiteUser < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true
  belongs_to :user, :touch => true

end
