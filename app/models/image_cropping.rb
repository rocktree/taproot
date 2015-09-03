# == Schema Information
#
# Table name: image_croppings
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  site_id    :integer
#  width      :integer
#  height     :integer
#  created_at :datetime
#  updated_at :datetime
#

class ImageCropping < ActiveRecord::Base

  # ------------------------------------------ Plugins

  has_superslug :title, :slug, :context => :site

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true

  # ------------------------------------------ Callbacks

  # after_save :update_images

  def update_images
    site.images.each do |image|
      if image.crop(slug).nil?
        crop_data = image.crop_data.merge(
          slug => {
            'x' => '0',
            'y' => '0',
            'width' => width.to_s,
            'height' => height.to_s,
          }
        )
        image.update_columns(:crop_data => crop_data)
      end
    end
  end

end
