module FreshlyEvents
  module Adapters
    # An adapter implementing method [#publish] to send data to STDOUT
    #
    class StdoutAdapter < Base
      # @param event_data [Hash] The data to be published to STDOUT
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
