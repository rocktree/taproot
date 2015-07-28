ActionMailer::Base.default_url_options = { :host => TopkitSetting.url }

if Rails.env.development? || Rails.env.test?
  # use mailcatcher in development (http://mailcatcher.me/)
  ActionMailer::Base.smtp_settings = {
    :address => '127.0.0.1',
    :port => 1025
  }
else
  ActionMailer::Base.smtp_settings = {
    :user_name => TopkitSetting.mailer.user_name,
    :password => TopkitSetting.mailer.password,
    :domain => TopkitSetting.mailer.domain,
    :address => TopkitSetting.mailer.address,
    :port => TopkitSetting.mailer.port,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
