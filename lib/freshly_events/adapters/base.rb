# frozen_string_literal: true

module FreshlyEvents
  module Adapters
    # An abstract base class for implementing adapters
    #
    # @abstract
    #
    class Base
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
