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
      #
      config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log", shift_age = 'daily')
      config.load_defaults 6.1
      # Only loads a smaller set of middleware suitable for API only apps.
      # Middleware like session, flash, cookies can be added back manually.
      # Skip views, helpers and assets when generating a new resource.
      config.api_only = true

      config.x.ipfs_host = ENV.fetch('IPFS_HOST', 'http://127.0.0.1:5001')
      config.x.temp_folder = ENV.fetch('TEMP_FOLDER', '/Users/piaocg/Workspace/nash/nash-temp')
      config.x.gateway = ENV.fetch('GATEWAY', 'https://ipfs.io/ipfs')
      config.x.hook_ops_error = ENV.fetch('HOOK_OPS_ERROR', 'https://chat.googleapis.com/v1/spaces/AAAA7hmt0E0/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=Xxu0uleVutbJMdLZqwFqn640vB1gBhyAofEAYO7LrAw%3D')
      config.x.stripe_client_secret = ENV.fetch('STRIPE_CLIENT_SECRET', 'sk_test_51IMkwGCJyYRpjym4QPRx6KypnfCYeqqqrKGlSTrUCj2RGCnQzEYOVpSiDvMxba9d7r1mIewErX2p73MOYinXef0H00yNKSKTYi')
      config.x.stripe_api_key = ENV.fetch('STRIPE_API_KEY', 'pk_test_51IMkwGCJyYRpjym40xQWNXEr3Axze0PJ2THfh4QXgqPk4SmhL4msxxueWHlPTU4aW0Uq0sMPNuARdjAq7ayiLRUb00WTuTtbgD')
   end
end
