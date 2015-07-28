# == Schema Information
#
# Table name: form_files
#
#  id                 :integer          not null, primary key
#  form_submission_id :integer
#  file_uid           :string(255)
#  file_name          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class FormFile < ActiveRecord::Base

  # ------------------------------------------ Associations

  belongs_to :form_submission

  # ------------------------------------------ Callbacks

  after_save :cache_attrs

  def cache_attrs
    update_columns(:file_name => self.file.meta['name'])
  end

end
