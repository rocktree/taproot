if Rails.env.production?
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    :email => {
      :email_prefix => SapwoodSetting.errors.email_prefix,
      :sender_address => [SapwoodSetting.errors.sender],
      :exception_recipients => [SapwoodSetting.errors.recipient]
    }
  )
end
