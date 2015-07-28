if Rails.env.production?
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    :email => {
      :email_prefix => TopkitSetting.errors.email_prefix,
      :sender_address => [TopkitSetting.errors.sender],
      :exception_recipients => [TopkitSetting.errors.recipient]
    }
  )
end
