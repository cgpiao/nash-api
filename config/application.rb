require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
   class Application < Rails::Application
      # Initialize configuration defaults for originally generated Rails version.
      config.load_defaults 6.1
      # Only loads a smaller set of middleware suitable for API only apps.
      # Middleware like session, flash, cookies can be added back manually.
      # Skip views, helpers and assets when generating a new resource.
      config.api_only = true

      config.x.ipfs_host = ENV.fetch('IPFS_HOST', 'http://127.0.0.1:5001')
      config.x.temp_folder = ENV.fetch('TEMP_FOLDER', '/Users/piaocg/Workspace/nash/nash-temp')
      config.x.gateway = ENV.fetch('GATEWAY', 'https://ipfs.io/ipfs')
   end
end
