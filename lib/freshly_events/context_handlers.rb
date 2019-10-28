require 'freshly_events/context_handlers/base'
require 'freshly_events/context_handlers/rails/controller'
require 'freshly_events/context_handlers/rails/active_job'
require 'freshly_events/context_handlers/collection'

module FreshlyEvents
  module ContextHandlers
    class << self
      attr_writer :known
      ##
      # @return [#publish] A list of handlers with method #publish
      #
      def known
        @known ||= FreshlyEvents::ContextHandlers::Collection.new
      end
    end

    known.register FreshlyEvents::ContextHandlers::Rails::Controller
    known.register FreshlyEvents::ContextHandlers::Rails::ActiveJob
  end
end
