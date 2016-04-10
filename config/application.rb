require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)



module Arrietty
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.filepicker_rails.api_key = ENV['FILEPICKER_API_KEY']

    config.action_mailer.smtp_settings = {
      address: "smtp.mailgun.org",
      port: 587, # ports 587 and 2525 are also supported with STARTTLS
      enable_starttls_auto: true, # detects and uses STARTTLS
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'], # SMTP password is any valid API key
      authentication: 'login', # Mailgun supports 'plain' or 'login'
    }
   
    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        access_key_id: ENV["S3_ACCESS_KEY_ID"],
        secret_access_key: ENV["S3_ACCESS_KEY_SECRET"],
        bucket: "hackeryou-arrietty"
      },
      :url =>':s3_domain_url',
      :path => '/:class/:attachment/:id_partition/:style/:filename'
    }
  end
end
