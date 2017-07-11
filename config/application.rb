require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# # Load application ENV vars and merge with existing ENV vars. Loaded here so can use values in initializers.
# ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module Energyx2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib', 'inputs')

    # ActsAsTaggableOn.force_binary_collation = true
    ActsAsTaggableOn.remove_unused_tags = true
    ActsAsTaggableOn.force_lowercase = true

    config.active_job.queue_adapter = :sidekiq

    config.paperclip_defaults = {
      storage: :s3,
      s3_region: ENV['AWS_REGION'],
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      }
    }

    config.action_mailer.default_url_options = { :host => Rails.env.development? ? "energyx2.dev" : "energyx2.herokuapp.com" }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: Rails.env.development? ? "energyx2.dev" : "energyx2.herokuapp.com",
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: ENV["GMAIL_USERNAME"],
      password: ENV["GMAIL_PASSWORD"]
    }
  end
end
