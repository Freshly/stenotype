# frozen_string_literal: true

module FreshlyEvents
  class EventSerializer
    attr_reader :event

    #
    # @param [Event]
    #
    def initialize(event)
      @event = event
    end

    #
    # @return [Hash] A hash representation of the event and its context
    #
    def serialize
      {
        **event_data,
        **event_options,
        **default_options,
        **eval_context_options,
      }
    end

    private

    def event_data
      event.data
    end

    def event_options
      event.options
    end

    def eval_context
      event.eval_context
    end

    def eval_context_options
      eval_context.map do |context_name, context|
        handler = FreshlyEvents::ContextHandlers.known.choose(handler_name: context_name)
        handler.new(context).as_json
      end.reduce(:merge!) || {}
    end

    def default_options
      { timestamp: Time.now.utc }
    end
  end
end
