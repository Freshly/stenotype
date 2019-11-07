# frozen_string_literal: true

module Hubbub
  #
  # A namespace containing implementations of various adapters
  # for publishing events to various destinations.
  # e. g. (Google Cloud, Kafka, Stdout, other)
  #
  module Adapters
    # An abstract base class for implementing adapters
    #
    # @abstract
    #
    class Base
      attr_reader :client

      def initialize(client: nil)
        @client = client
      end

      #
      # This method is expected to be implemented by subclasses
      # @abstract
      # @raise [NotImplementedError] unless implemented in a subclass
      #
      def publish(_event_data, **_additional_arguments)
        raise NotImplementedError,
              "#{self.class.name} must implement method #publish"
      end
    end
  end
end
