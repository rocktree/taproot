# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  settings               :text
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

  scope :alpha, -> { all.to_a.sort_by(&:last_name) }

  # ------------------------------------------ Callbacks

  before_create :set_api_key

  # ------------------------------------------ Instance Methods

  def first_site
    sites.alpha.first
  end

  def has_sites?
    sites.size > 0
  end

  def has_multiple_sites?
    sites.size > 1
  end

  def as_json(options)
    super(
      :only => [:name, :email, :api_key],
      :include => { :sites => { :only => [:title, :uid] } }
    )
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
