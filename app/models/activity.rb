# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  item_type  :string(255)
#  item_id    :integer
#  item_path  :string(255)
#  site_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base

  belongs_to :site
  belongs_to :item, :polymorphic => true
  belongs_to :user

end
