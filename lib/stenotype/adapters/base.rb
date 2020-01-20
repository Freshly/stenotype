# frozen_string_literal: true

module Stenotype
  #
  # A namespace containing implementations of various adapters
  # for publishing events to various destinations.
  # e. g. (Google Cloud, Kafka, Stdout, other)
  #
  module Adapters
    #
    # An abstract base class for implementing adapters
    #
    # @abstract
    # @example Defining a custom adapter
    #  MyCustomAdapter < Stenotype::Adapters::Base
    #    def publish(event_data, **additional_arguments)
    #      client.publish(event_data, **additional_arguments)
    #    end
    #
    #    def client
    #      @client ||= SomeCustomClient.new(some_credential)
    #    end
    #  end
    #
    class Base
      attr_reader :client

      #
      # @return {#publish} An adapter implementing method [#publish]
      #
      def initialize(client: nil)
        @client = client
      end

      #
      # This method is expected to be implemented by subclasses
      # @abstract
      # @raise {NotImplementedError} unless implemented in a subclass
      #
      def publish(_event_data, **_additional_attrs)
        raise NotImplementedError,
              "#{self.class.name} must implement method #publish"
      end

      #
      # Allows custom setup of the adapter. Noop by default
      # @abstract
      #
      def setup!
        # noop by default
      end

      #
      # This method is expected to be implemented by subclasses. In case async
      # publisher is used the process might end before the async queue of
      # messages is processed, so this method is going to be used in a
      # `at_exit` hook to flush the queue.
      # @abstract
      # @raise {NotImplementedError} unless implemented in a subclass
      #
      def flush!
        raise NotImplementedError,
              "#{self.class.name} must implement method #flush"
      end
    end
  end
end
