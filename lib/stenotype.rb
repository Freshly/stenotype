# frozen_string_literal: true

#
# A top level namespace for the freshly-events gem
#
module Stenotype
  class << self
    ##
    # Configures the library.
    # @yield {Stenotype::Configuration}
    #
    # @example
    #
    #   Stenotype.configure do |config|
    #     config.targets = [
    #       Stenotype::Adapters::StdoutAdapter.new,
    #       Stenotype::Adapters::GoogleCloud.new
    #     ]
    #
    #      config.dispatcher     = Stenotype::Dispatcher.new
    #      config.gc_project_id  = ENV['GC_PROJECT_ID']
    #      config.gc_credentials = ENV['GC_CREDENTIALS']
    #      config.gc_topic       = ENV['GC_TOPIC']
    #      config.gc_mode        = :async
    #   end
    #
    def configure(&block)
      Stenotype::Configuration.configure(&block)
    end

    ##
    # @return {Stenotype::Configuration}
    #
    def config
      Stenotype::Configuration
    end
  end
end

require "stenotype/adapters"
require "stenotype/configuration"
require "stenotype/context_handlers"
require "stenotype/dispatcher"
require "stenotype/event"
require "stenotype/event_serializer"
require "stenotype/exceptions"
require "stenotype/version"
require "stenotype/frameworks/object_ext"

Stenotype.configure do |config|
  config.uuid_generator = SecureRandom
  config.dispatcher     = Stenotype::Dispatcher.new

  config.gc_project_id  = ENV['GC_PROJECT_ID']
  config.gc_credentials = ENV['GC_CREDENTIALS']
  config.gc_topic       = ENV['GC_TOPIC']
  config.gc_mode        = :async

  config.targets = [
    Stenotype::Adapters::StdoutAdapter.new,
    Stenotype::Adapters::GoogleCloud.new
  ]

  Stenotype::ContextHandlers.module_eval do
    register Stenotype::ContextHandlers::Klass
  end

  Object.send(:include, Stenotype::Frameworks::ObjectExt)
end

if defined?(Rails)
  require "stenotype/frameworks/rails/action_controller"
  require "stenotype/frameworks/rails/active_job"

  module Stenotype
    class Railtie < Rails::Railtie # :nodoc:
      config.stenotype = Stenotype.config

      #
      # Register Rails handlers
      #
      Stenotype::ContextHandlers.module_eval do
        register Stenotype::ContextHandlers::Rails::Controller
        register Stenotype::ContextHandlers::Rails::ActiveJob
      end

      ActiveSupport.on_load(:action_controller) do
        include Stenotype::Frameworks::Rails::ActionControllerExtension
      end

      ActiveSupport.on_load(:active_job) do
        # @todo: consider using `::ActiveJob::Base.around_perform`
        #        or `::ActiveJob::Base.around_enqueue`
        extend Stenotype::Frameworks::Rails::ActiveJobExtension
      end
    end
  end
end
