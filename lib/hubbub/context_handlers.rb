# frozen_string_literal: true

require 'hubbub/context_handlers/base'
require 'hubbub/context_handlers/rails/controller'
require 'hubbub/context_handlers/rails/active_job'
require 'hubbub/context_handlers/klass'
require 'hubbub/context_handlers/collection'

module Hubbub
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
        @known ||= Hubbub::ContextHandlers::Collection.new
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
