require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret SapwoodSetting.dragonfly.secret

  url_format "/media/:job/:name"

  datastore :s3,
    :bucket_name          => SapwoodSetting.aws.bucket,
    :access_key_id        => SapwoodSetting.aws.access_key_id,
    :secret_access_key    => SapwoodSetting.aws.secret_access_key,
    :url_scheme           => 'https'

end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
