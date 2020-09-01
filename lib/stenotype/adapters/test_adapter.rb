# frozen_string_literal: true

module Stenotype
  module Adapters
    class TestAdapter < Base
      attr_reader :buffer

      def initialize(*_)
        @buffer = Array.new
        super()
      end

      #
      # @param event_data {Sting} The data to be published
      # @param additional_attrs {Hash} The list of additional event attributes
      #
      def publish(event_data, **additional_attrs)
        buffer << parse(event_data)
      end

      #
      # Clears the buffer
      #
      def flush!
        buffer.clear
      end

      private

      def parse(event_data)
        JSON.parse(event_data)
      end
    end
  end
end
