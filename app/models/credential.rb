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
require 'securerandom'

class Credential < ActiveRecord::Base

  # ------------------------------------------ Validations

  validates :key, :length => { :is => 16 },
                  :uniqueness => true
  validates :secret, :length => { :is => 35 },
                     :format => { :with => /[a-zA-Z0-9]{12}\/[a-zA-Z0-9]{22}/ }

  # ------------------------------------------ Class Methods

  def self.generate_key!
    SecureRandom.hex(8)
  end

  def self.generate_secret!
    "#{SecureRandom.hex(6)}/#{SecureRandom.hex(11)}"
  end

end

Credential.new(:key => Credential.generate_key!, :secret => Credential.generate_secret!).valid?
