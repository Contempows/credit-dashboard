require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stc
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('/app/assets/fonts')
    config.assets.precompile += %w( .svg .eot .woff .ttf .otf)
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.generators do |g|
      g.test_framework  :test_unit, fixture: true
    end
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_job.queue_adapter = :sidekiq
  end
end
