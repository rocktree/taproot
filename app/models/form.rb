# == Schema Information
#
# Table name: forms
#
#  id                  :integer          not null, primary key
#  site_id             :integer
#  title               :string(255)
#  slug                :string(255)
#  description         :text
#  body                :text
#  thank_you_body      :text
#  notification_emails :text
#  created_at          :datetime
#  updated_at          :datetime
#  key                 :string(255)
#  button_label        :string(255)
#  email_subject       :string(255)
#  email_body          :text
#  email_to_id         :integer
#

require 'csv'

class Form < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include SiteSlug

  has_paper_trail

  # ------------------------------------------ Associations

  belongs_to :site, :touch => true
  belongs_to :email_to, :class_name => FormField

  has_many :form_fields, :dependent => :destroy
  has_many :form_submissions, :dependent => :destroy

  accepts_nested_attributes_for :form_fields

  # ------------------------------------------ Validations

  validates :title, :presence => true

  # ------------------------------------------ Callbacks

  after_save :remove_blank_fields

  def remove_blank_fields
    form_fields.where("title = ''").destroy_all
  end

  after_create :add_key

  def add_key
    require 'digest/md5'
    logic = "form-#{id}-#{created_at}"
    self.update_columns(:key => Digest::MD5.hexdigest(logic))
  end

  # ------------------------------------------ Instance Methods

  def fields
    form_fields
  end

  def submissions
    form_submissions
  end

  def to_csv
    methods = fields.collect(&:slug)
    CSV.generate do |csv|
      csv << fields.collect(&:title) + ["Created At", "Last Updated"]
      submissions.includes(:form => [:form_fields]).each do |s|
        attrs = []
        methods.each do |m|
          attr = s.send(m)
          attrs << (attr.class == FormFile ? attr.file.name : attr)
        end
        attrs << s.created_at
        attrs << s.updated_at
        csv << attrs
      end
    end
  end

end
