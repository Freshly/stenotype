module FreshlyEvents
  module Adapters
    # An abstract base class for implementing adapters
    #
    # @abstract
    #
    class Base
      #
      # This method is expected to be implemented by subclasses
      #
      def publish(*event_data)
        raise NotImplementedError
      end
    end
  end
end
