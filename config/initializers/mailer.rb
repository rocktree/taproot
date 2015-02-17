ActionMailer::Base.default_url_options = { :host => SapwoodSetting.site.url }

if Rails.env.development?
  # use mailcatcher in development (http://mailcatcher.me/)
  ActionMailer::Base.smtp_settings = {
    :address => '127.0.0.1',
    :port => 1025
  }
else
  ActionMailer::Base.smtp_settings = {
    :user_name => SapwoodSetting.mailer.user_name,
    :password => SapwoodSetting.mailer.password,
    :domain => SapwoodSetting.mailer.domain,
    :address => SapwoodSetting.mailer.address,
    :port => SapwoodSetting.mailer.port,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
