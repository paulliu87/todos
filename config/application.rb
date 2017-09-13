require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Todos
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

class Application < Rails::Application
    config.assets.paths << "#{Rails}/app/assets/fonts"
    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Required for Devise on Heroku
    config.assets.initialize_on_precompile = false

    # config.autoload_paths += %W(#{config.root}/app/models/thawing-chamber-42985)
    # config.assets.precompile += Todos.assets
    # config.assets.precompile += %w(thawing-chamber-42985/*)
    config.assets.precompile += %w( .svg .eot .woff .ttf )
    config.assets.precompile += [ 'styles.css.scss']
    config.assets.precompile += [
        'glyphicons-halflings.png',
        'glyphicons-halflings-white.png'
      ]
end
