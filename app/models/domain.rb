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

class Domain < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :site, :touch => :true

  # ------------------------------------------ Instance Methods

  after_save { Rails.application.reload_routes! }

end
