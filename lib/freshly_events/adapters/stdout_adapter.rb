module FreshlyEvents
  module Adapters
    class StdoutAdapter < BaseAdapter
      def publish(*event_data)
        client.info(event_data)
      end

      private

      def client
        @client ||= Logger.new(STDOUT)
      end
    end
  end
end
