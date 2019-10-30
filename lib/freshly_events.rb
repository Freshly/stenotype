require 'pry'

module FreshlyEvents
  class << self
    ##
    # Configures the library.
    # :yields: [FreshlyEvents::Configuration]
    #
    # @example
    #
    #   FreshlyEvents.configure do |config|
    #     config.targets = [
    #       FreshlyEvents::Adapters::StdoutAdapter.new,
    #       FreshlyEvents::Adapters::GoogleCloud.new
    #     ]
    #
    #      config.dispatcher     = FreshlyEvents::Dispatcher.new
    #      config.gc_project_id  = "freshly-events"
    #      config.gc_credentials = "/Users/matthewhensrud/Freshly/gcp.json"
    #      config.gc_topic       = 'projects/freshly-events/topics/sandbox'
    #      config.gc_mode        = :async
    #   end
    #
    def configure(&block)
      FreshlyEvents::Configuration.configure(&block)
    end

    ##
    # @return [FreshlyEvents::Configuration]
    #
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
require 'freshly_events/exceptions'
require 'freshly_events/version'
require 'freshly_events/frameworks/object_ext'

FreshlyEvents.configure do |config|
  config.targets = [
    FreshlyEvents::Adapters::StdoutAdapter.new,
    FreshlyEvents::Adapters::GoogleCloud.new
  ]

  config.dispatcher     = FreshlyEvents::Dispatcher.new
  config.gc_project_id  = "freshly-events"
  config.gc_credentials = "/Users/matthewhensrud/Freshly/gcp.json"
  config.gc_topic       = 'projects/freshly-events/topics/sandbox'
  config.gc_mode        = :async # either of [:sync, :async]

  FreshlyEvents::ContextHandlers.module_eval do
    register FreshlyEvents::ContextHandlers::Klass
  end
end

if defined?(Rails)
  require 'freshly_events/frameworks/rails/action_controller'
  require 'freshly_events/frameworks/rails/active_job'

  module FreshlyEvents
    class Railtie < Rails::Railtie # :nodoc:
      config.freshly_events = FreshlyEvents.config

      #
      # Register Rails handlers
      #
      FreshlyEvents::ContextHandlers.module_eval do
        register FreshlyEvents::ContextHandlers::Rails::Controller
        register FreshlyEvents::ContextHandlers::Rails::ActiveJob
      end

      ActiveSupport.on_load(:action_controller) do
        include FreshlyEvents::Frameworks::Rails::ActionControllerExtension
      end

      ActiveSupport.on_load(:active_job) do
        extend FreshlyEvents::Frameworks::Rails::ActiveJobExtension
      end
    end
  end
end
