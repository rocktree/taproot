Rails.application.config.middleware.use(
  ExceptionNotification::Rack,
  :email => {
    :email_prefix => TaprootSetting.notifications.errors.email_prefix,
    :sender_address => [TaprootSetting.notifications.errors.sender],
    :exception_recipients => [TaprootSetting.notifications.errors.recipient]
  }
)
