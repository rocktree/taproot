# == Schema Information
#
# Table name: form_submissions
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  idx        :integer          default(0)
#  field_data :text
#  created_at :datetime
#  updated_at :datetime
#

class FormSubmission < ActiveRecord::Base

  # ------------------------------------------ Plugins

  include FormIdx

  # ------------------------------------------ Attributes

  serialize :field_data, Hash

  # ------------------------------------------ Associations

  belongs_to :form, :touch => true

  has_many :form_files

  # ------------------------------------------ Scopes

  scope :desc, -> { order('created_at desc') }

  # ------------------------------------------ Callbacks

  after_create :send_response

  # ------------------------------------------ Instance Methods

  def title
    field_data[field_data.keys.first]
  end

  def send_notification
    form = self.form
    return false if form.notification_emails.blank?
    emails = []
    form.notification_emails.split("\n").collect(&:strip).each do |email|
      email_options = email.split('|')
      if email_options.size > 1
        if self.field_data[email_options[1]].strip == email_options[2].strip
          emails << email_options[0]
        end
      else
        emails << email
      end
    end
    FormsMailer.new_submission(self, emails).deliver
  end

  def send_response
    form = self.form
    if form.email_subject.present? &&
      form.email_body.present? &&
      form.email_to_id.present?
        FormsMailer.response_message(
          self.field_data[form.email_to.slug],
          form
        ).deliver
    end
  end

  def respond_to?(method, include_private = false)
    if !form.nil? && form_fields.collect(&:slug).include?(method.to_s)
      return true
    end
    super
  end

  def method_missing(method, *arguments, &block)
    begin
      super
    rescue
      if !field_data[method.downcase.to_s].nil?
        field_data[method.downcase.to_s]
      elsif respond_to?(method)
        if field_data["rtfile_#{method.to_s}"].present?
          file = form_files.select { |file|
            file.id == field_data["rtfile_#{method.to_s}"].to_i
          }.first
          # file.nil? ? "" : file.file.url
          file.nil? ? "" : file
        else
          ""
        end
      else
        super
      end
    end
  end

  def form_fields
    form.form_fields
  end

end
