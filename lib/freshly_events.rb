require "freshly_events/version"

module FreshlyEvents
  class << self
    def configure(&block)
      FreshlyEvents::Configuration.configure(&block)
    end

    def config
      FreshlyEvents::Configuration
    end
  end
end

require 'freshly_events/adapters'
require 'freshly_events/configuration'
require 'freshly_events/context_handlers'
require 'freshly_events/dispatcher'
require 'freshly_events/event'
require 'freshly_events/version'

if defined?(Rails)
  module FreshlyEvents
    class Railtie < Rails::Railtie
      config.freshly_events = FreshlyEvents.configure do |config|
        config.targets = [
          FreshlyEvents::Adapters::StdoutAdapter.new
        ]
        config
      end
    end
  end
else
  FreshlyEvents.configure do |config|
    config.targets = [
      FreshlyEvents::Adapters::StdoutAdapter.new,
      FreshlyEvents::Adapters::GoogleCloud.new
    ]

    config.dispatcher     = FreshlyEvents::Dispatcher.new
    config.gc_project_id  = "freshly-events"
    config.gc_credentials = "/Users/rkapitonov/.auth/key.json"
    config.gc_topic       = 'projects/freshly-events/topics/sandbox'
    config.gc_mode        = :async
  end
end
