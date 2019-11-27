# frozen_string_literal: true

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
    #
    # @example
    #   Stenotype.config #=> StenotypeConfiguation
    #
    # @return {Stenotype::Configuration}
    #
    def config
      Stenotype::Configuration.config
    end
  end
end

require 'spicerack'
require 'spicerack/configurable'

require "stenotype/adapters"
require "stenotype/configuration"
require "stenotype/context_handlers"
require "stenotype/dispatcher"
require "stenotype/event"
require "stenotype/event_serializer"
require "stenotype/version"
require "stenotype/emitter"

Stenotype::Configuration.configure do |config|
  config.uuid_generator = SecureRandom
  config.dispatcher     = Stenotype::Dispatcher.new

  config.google_cloud do |gc|
    gc.project_id  = ENV['GC_PROJECT_ID']
    gc.credentials = ENV['GC_CREDENTIALS']
    gc.topic       = ENV['GC_TOPIC']
    gc.mode        = :async
  end

  config.targets = [
    Stenotype::Adapters::StdoutAdapter.new,
    Stenotype::Adapters::GoogleCloud.new
  ]

  Stenotype::ContextHandlers.module_eval do
    register Stenotype::ContextHandlers::Klass
  end
end

require "stenotype/railtie" if defined?(Rails)
