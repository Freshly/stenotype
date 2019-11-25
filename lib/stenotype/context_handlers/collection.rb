# frozen_string_literal: true

module Stenotype
  module ContextHandlers
    #
    # A class representing a list of available context handlers
    # @example Complete usage overview
    #   class MyCustomHander
    #     self.handler_name = :custom_handler
    #
    #     def as_json(*_args)
    #       {
    #         key: :value
    #       }
    #     end
    #   end
    #
    #   collection = Stenotype::ContextHandlers::Collection.new
    #   collection.register(MyCustomHandler)
    #
    #   collection.registered?(MyCustomHandler) #=> true
    #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
    #   collection.unregister(MyCustomHandler)
    #   collection.registered?(MyCustomHandler) #=> false
    #
    #   collection.register(SomeRandomClass) #=> ArgumentError
    #   collection.unregister(SomeRandomClass) #=> ArgumentError
    #   collection.choose(handler_name: :unknown) #=> Stenotype::Errors::UnknownHandler
    #
    class Collection < Array
      #
      # Return a handler with given handler_name if found in collection,
      # raises if a handler is not registered
      #
      # @param handler_name {Symbol} a handler to be found in the collection
      # @raise {Stenotype::Errors::UnknownHandler} in case a handler is not registered
      # @return {#as_json} A handler which respond to #as_json
      #
      # @example When a handler is present in the collection
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
      #
      # @example When a handler is not present in the collection
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
      #
      def choose(handler_name:)
        handler = detect { |e| e.handler_name == handler_name }
        handler || raise(Stenotype::Errors::UnknownHandler,
                         "Handler '#{handler_name}' is not found. " \
                         "Please make sure the handler you've specified is " \
                         'registered in the list of known handlers. ' \
                         "See #{Stenotype::ContextHandlers} for more information.")
      end

      #
      # Registers a new handler. Checks handler type before adding
      #
      # @param handler {#as_json} a new handler to be added to collection
      # @raise {ArgumentError} in case handler does not inherit from {Stenotype::ContextHandlers::Base}
      # @return {Stenotype::ContextHandlers::Collection} a collection object
      #
      # @example When a handler inherits from Stenotype::ContextHandlers::Base
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #
      # @example When a handler doesn't inherit from Stenotype::ContextHandlers::Base
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(NotInheritedFromHandlerBase) # => ArgumentError
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
      # Removes a registered handler. Checks handler type before removing
      #
      # @example When a handler inherits from Stenotype::ContextHandlers::Base
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #   collection.unregister(MyCustomHandler) # removes MyCustomHandler from the list of handlers
      #
      # @example When a handler doesn't inherit from Stenotype::ContextHandlers::Base
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.unregister(MyCustomHandler) # ArgumentError
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
      # Checks whether a given handler is registered in collection
      #
      # @example When a handler is registered
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #   collection.registered?(MyCustomHandler) # true
      #
      # @example When a handler is not registered
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.registered?(UnregisteredHandler) # false
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
