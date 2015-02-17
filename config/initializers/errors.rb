if Rails.env.production?
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    :email => {
      :email_prefix => SapwoodSetting.notifications.errors.email_prefix,
      :sender_address => [SapwoodSetting.notifications.errors.sender],
      :exception_recipients => [SapwoodSetting.notifications.errors.recipient]
    }
  )
end
