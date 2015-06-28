# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  settings               :text
#  admin                  :boolean          default(FALSE)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  fb_access_token        :string(255)
#  fb_token_expires       :datetime
#

class User < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include ActivityLog

  # ------------------------------------------ Devise

  devise :database_authenticatable, :recoverable, :trackable, :validatable

  # ------------------------------------------ Attributes

  serialize :settings

  # ------------------------------------------ Associations

  has_many :site_users
  has_many :sites, :through => :site_users
  has_many :activities

  # ------------------------------------------ Validations

  validates :email, :presence => true

  # ------------------------------------------ Scopes

  scope :admins, -> { where(:admin => true) }
  scope :alpha, -> { all.to_a.sort_by(&:last_name) }

  # ------------------------------------------ Instance Methods

  def display_name
    name || email
  end

  def first_name
    return email if name.nil?
    name.split(' ').first
  end

  def last_name
    return email if name.nil?
    name.split(' ').last
  end

  def site_user?
    !admin?
  end

  def title
    display_name
  end

  private

    def save_activity
      Activity.create(
        :item => self,
        :site => nil,
        :item_path => nil,
        :user => RequestStore.store[:sapwood],
        :action => self.new_record? ? 'created' : 'updated'
      )
    end

end
