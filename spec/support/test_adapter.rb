# frozen_string_literal: true

require 'freshly_events/adapters/base'

module FreshlyEvents
  class TestAdapter < FreshlyEvents::Adapters::Base
    attr_writer :buffer

    def initialize(buffer = [])
      @buffer = buffer
      super()
    end

    def publish(event_data)
      buffer << event_data
    end

    def buffer
      @buffer || raise(NotImplementedError,
                       'Please specify a buffer for test adapter')
    end
  end
end
