# frozen_string_literal: true

module Hubbub
  class TestDispatcher
    attr_accessor :dispatched_events

    def initialize
      @dispatched_events = []
    end

    def publish(event)
      dispatched_events << event
    end
  end
end
