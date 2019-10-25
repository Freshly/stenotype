module FreshlyEvents
  module Adapters
    class Base
      def publish(*event_data)
        raise NotImplementedError
      end
    end
  end
end
