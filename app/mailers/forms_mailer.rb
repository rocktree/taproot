class FormsMailer < ActionMailer::Base
  default :from => SapwoodSetting.mailer.default_from

  if Rails.env.production? && SapwoodSetting.mailer.sendgrid.to_bool == true
    include SendGrid
  end

  def new_submission(submission, emails)
    @submission = submission
    @form = @submission.form
    @site = @form.site
    mail(
      :to => emails, 
      :subject => "[#{@site.title}] New #{@form.title} Submission"
    )
  end

  def response_message(to, form)
    @form = form
    mail(
      :to => to,
      :subject => form.email_subject
    )
  end

end
