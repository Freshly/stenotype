# frozen_string_literal: true

require 'freshly_events/context_handlers/base'
require 'freshly_events/context_handlers/rails/controller'
require 'freshly_events/context_handlers/rails/active_job'
require 'freshly_events/context_handlers/klass'
require 'freshly_events/context_handlers/collection'

module FreshlyEvents
  #
  # A namespace to contain various context
  # handlers implementations
  #
  module ContextHandlers
    class << self
      attr_writer :known
      #
      # @return {Array<#publish>} A list of handlers implementing [#publish]
      #
      def known
        @known ||= FreshlyEvents::ContextHandlers::Collection.new
      end

      #
      # @param handler {#publish} A handler with implemented method [#publish]
      #
      def register(handler)
        known.register(handler)
      end
    end
  end
end
