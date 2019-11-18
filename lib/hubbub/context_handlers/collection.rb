# frozen_string_literal: true

module Hubbub
  module ContextHandlers
    #
    # A class representing a list of available context handlers
    #
    class Collection < Array
      #
      # @param handler_name {Symbol} a handler to be found in the collection
      # @raise {Hubbub::Exceptions::UnknownHandler} in case a handler is not registered
      # @return {#as_json} A handler which respond to #as_json
      #
      def choose(handler_name:)
        handler = detect { |e| e.handler_name == handler_name }
        handler || raise(Hubbub::Exceptions::UnknownHandler,
                         "Handler '#{handler_name}' is not found. " \
                         "Please make sure the handler you've specified is " \
                         'registered in the list of known handlers. ' \
                         "See #{Hubbub::ContextHandlers} for more information.")
      end

      #
      # @param handler {#as_json} a new handler to be added to collection
      # @raise {NotImplementedError} in case handler does not inherit from {Hubbub::ContextHandlers::Base}
      #
      def register(handler)
        unless handler < Hubbub::ContextHandlers::Base
          raise NotImplementedError,
                "Handler must inherit from #{Hubbub::ContextHandlers::Base}, " \
                "but inherited from #{handler.superclass}"
        end

        push(handler) unless registered?(handler)
      end

      #
      # @param handler {#as_json} a handler to be removed from the collection of known handlers
      # @raise {NotIMplementedError} in case handler does not inherit from {Hubbub::ContextHandlers::Base}
      #
      def unregister(handler)
        unless handler < Hubbub::ContextHandlers::Base
          raise NotImplementedError,
                "Handler must inherit from #{Hubbub::ContextHandlers::Base}, " \
                "but inherited from #{handler.superclass}"
        end

        delete(handler) if registered?(handler)
      end

      #
      # @param handler {#as_json} a handler to be checked for presence in a collection
      # @return [true, false]
      #
      def registered?(handler)
        include?(handler)
      end
    end
  end
end
