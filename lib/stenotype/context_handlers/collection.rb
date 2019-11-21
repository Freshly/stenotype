# frozen_string_literal: true

module Stenotype
  module ContextHandlers
    #
    # A class representing a list of available context handlers
    #
    class Collection < Array
      #
      # @param handler_name {Symbol} a handler to be found in the collection
      # @raise {Stenotype::Exceptions::UnknownHandler} in case a handler is not registered
      # @return {#as_json} A handler which respond to #as_json
      #
      def choose(handler_name:)
        handler = detect { |e| e.handler_name == handler_name }
        handler || raise(Stenotype::Exceptions::UnknownHandler,
                         "Handler '#{handler_name}' is not found. " \
                         "Please make sure the handler you've specified is " \
                         'registered in the list of known handlers. ' \
                         "See #{Stenotype::ContextHandlers} for more information.")
      end

      #
      # @param handler {#as_json} a new handler to be added to collection
      # @raise {ArgumentError} in case handler does not inherit from {Stenotype::ContextHandlers::Base}
      # @return {Stenotype::ContextHandlers::Collection} a collection object
      #
      def register(handler)
        unless handler < Stenotype::ContextHandlers::Base
          raise ArgumentError,
                "Handler must inherit from #{Stenotype::ContextHandlers::Base}, " \
                "but inherited from #{handler.superclass}"
        end

        push(handler) unless registered?(handler)
        self
      end

      #
      # @param handler {#as_json} a handler to be removed from the collection of known handlers
      # @raise {ArgumentError} in case handler does not inherit from {Stenotype::ContextHandlers::Base}
      # @return {Stenotype::ContextHandlers::Collection} a collection object
      #
      def unregister(handler)
        unless handler < Stenotype::ContextHandlers::Base
          raise ArgumentError,
                "Handler must inherit from #{Stenotype::ContextHandlers::Base}, " \
                "but inherited from #{handler.superclass}"
        end

        delete(handler) if registered?(handler)
        self
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
