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

class ReferenceCache < ActiveRecord::Base

  belongs_to :item, :polymorphic => true

end
