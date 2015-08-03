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
#  api_key                :string(255)
#

class User < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include ActivityLog, Presenter

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
  validates :api_key, :uniqueness => true

  # ------------------------------------------ Scopes

  scope :admins, -> { where(:admin => true) }
  scope :alpha, -> { all.to_a.sort_by(&:last_name) }

  # ------------------------------------------ Callbacks

  before_create :set_api_key

  # ------------------------------------------ Instance Methods

  def is_admin?
    admin?
  end

  def site_user?
    !admin?
  end

  def all_sites
    @all_sites ||= admin? ? Site.alpha : sites.alpha
  end

  def first_site
    @first_site ||= all_sites.first
  end

  def has_sites?
    all_sites.size > 0
  end

  private

    def save_activity
      Activity.create(
        :item => self,
        :site => nil,
        :item_path => nil,
        :user => RequestStore.store[:topkit],
        :action => self.new_record? ? 'created' : 'updated'
      )
    end

    def set_api_key
      self.api_key = SecureRandom.hex(16)
    end

end
