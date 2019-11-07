# frozen_string_literal: true

#
# A top level namespace for the freshly-events gem
#
module Hubbub
  class << self
    ##
    # Configures the library.
    # :yields: {Hubbub::Configuration}
    #
    # @example
    #
    #   Hubbub.configure do |config|
    #     config.targets = [
    #       Hubbub::Adapters::StdoutAdapter.new,
    #       Hubbub::Adapters::GoogleCloud.new
    #     ]
    #
    #      config.dispatcher     = Hubbub::Dispatcher.new
    #      config.gc_project_id  = "freshly-events"
    #      config.gc_credentials = "/Users/matthewhensrud/Freshly/gcp.json"
    #      config.gc_topic       = "projects/freshly-events/topics/sandbox"
    #      config.gc_mode        = :async
    #   end
    #
    def configure(&block)
      Hubbub::Configuration.configure(&block)
    end

    ##
    # @return {Hubbub::Configuration}
    #
    def config
      Hubbub::Configuration
    end
  end
end

require "hubbub/adapters"
require "hubbub/configuration"
require "hubbub/context_handlers"
require "hubbub/dispatcher"
require "hubbub/event"
require "hubbub/event_serializer"
require "hubbub/exceptions"
require "hubbub/version"
require "hubbub/frameworks/object_ext"

Hubbub.configure do |config|
  config.targets = [
    Hubbub::Adapters::StdoutAdapter.new,
    Hubbub::Adapters::GoogleCloud.new
  ]

  config.dispatcher     = Hubbub::Dispatcher.new
  config.gc_project_id  = 'freshly-events'
  config.gc_credentials = '/Users/rkapitonov/.auth/key.json'
  config.gc_topic       = 'projects/freshly-events/topics/sandbox'
  config.gc_mode        = :async # either of [:sync, :async]

  Hubbub::ContextHandlers.module_eval do
    register Hubbub::ContextHandlers::Klass
  end
end

if defined?(Rails)
  require "hubbub/frameworks/rails/action_controller"
  require "hubbub/frameworks/rails/active_job"

  module Hubbub
    class Railtie < Rails::Railtie # :nodoc:
      config.hubbub = Hubbub.config

      #
      # Register Rails handlers
      #
      Hubbub::ContextHandlers.module_eval do
        register Hubbub::ContextHandlers::Rails::Controller
        register Hubbub::ContextHandlers::Rails::ActiveJob
      end

      ActiveSupport.on_load(:action_controller) do
        include Hubbub::Frameworks::Rails::ActionControllerExtension
      end

      ActiveSupport.on_load(:active_job) do
        extend Hubbub::Frameworks::Rails::ActiveJobExtension
      end
    end
  end
end
