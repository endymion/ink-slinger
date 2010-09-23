require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module InkSlinger
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end
    config.generators do |g|
      g.template_engine :haml
    end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    # RSpec for testing.
    config.generators do |g|
      g.test_framework :rspec
    end
    
    # Paperclip custom processors.
    config.after_initialize do
      # copied from paperclip.rb: due to bundler, this doesn't seem to happen automagically anymore!?!
      Dir.glob(File.join(File.expand_path(Rails.root), "lib", "paperclip_processors", "*.rb")).each do |processor|
        require processor # PVDB don't rescue LoadError... let it rip!
      end
    end
    
  end
end

# This keeps S3 out of the picture except in production.  (See the setting in
# config/environments/production.rb)
PAPERCLIP_CONFIG = {}
PAPERCLIP_CONFIG_IMAGES = {
  :path => ":rails_root/public/system/:rails_env/images/:attachment/:id_partition/:basename.:extension",
  :url => "/system/:rails_env/images/:attachment/:id_partition/:basename.:extension"
}
PAPERCLIP_CONFIG_PANELS = {
  :path => ":rails_root/public/system/:rails_env/panels/:attachment/:id_partition/:basename.:extension",
  :url => "/system/:rails_env/panels/:attachment/:id_partition/:basename.:extension"
}

# Hook into the Rails page caching mechanism, writing cached pages in /tmp and
# copying them to S3.
require 'CachesPage_S3'

# Set this if the styles has changed recently and the CSS needs to be loaded
# from S3 instead of CloudFront.
STYLES_CHANGED_RECENTLY = true