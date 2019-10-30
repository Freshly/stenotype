require 'freshly_events/adapters/base'

module FreshlyEvents
  class TestAdapter < FreshlyEvents::Adapters::Base
    attr_accessor :buffer

    def publish(event_data)
      @buffer.push(event_data)
    end

    def buffer
      @buffer or raise NotImplementedError, 'Please specify a buffer in test mode'
    end
  end
end
