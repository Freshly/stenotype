# frozen_string_literal: true

require "spicery"

#
# A top level namespace for the freshly-events gem
#
module Stenotype
  #
  # A wrapper class for Stenotype specific errors
  #
  class StenotypeError < StandardError
  end

  #
  # A module enclosing all Stenotype errors.
  #
  module Errors
    #
    # This exception is being raised in case an unsupported mode
    # for Google Cloud is specified.
    #
    class GoogleCloudUnsupportedMode < StenotypeError; end

    #
    # This exception is being raised upon unsuccessful publishing of an event.
    #
    class MessageNotPublished < StenotypeError; end

    #
    # This exception is being raised in case no targets are
    # specified {Stenotype::Configuration}.
    #
    class NoTargetsSpecified < StenotypeError; end

    #
    # This exception is being raised upon using a context handler which
    # has never been registered in known handlers in {Stenotype::ContextHandlers::Collection}.
    #
    class UnknownHandler < StenotypeError; end
  end

  class << self
    ##
    # Configures the library. See also {Stenotype::Railtie} for Rails
    #   specific configuration.
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
    #
    #      config.enable_action_controller_extension = true
    #      config.enable_active_job_extension = true
    #   end
    #
    def configure(&block)
      Stenotype::Configuration.configure(&block)
    end

    #
    # @example
    #   Stenotype.config #=> StenotypeConfiguation
    #
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
require "stenotype/version"
require "stenotype/emitter"

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
end

require "stenotype/railtie" if defined?(Rails)
