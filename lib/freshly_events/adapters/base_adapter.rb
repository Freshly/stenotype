module FreshlyEvents
  module Adapters
    class BaseAdapter
      def publish(*event_data)
        raise NotImplementedError
      end
    end
  end
end
