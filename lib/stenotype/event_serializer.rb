# frozen_string_literal: true
require 'securerandom'

module Stenotype
  #
  # A class used to serialize a {Stenotype::Event}
  # upon publishing it to targets
  #
  class EventSerializer
    attr_reader :event, :uuid_generator

    #
    # @param event {Stenotype::Event}
    # @param uuid_generator {#uuid} an object responding to [#uuid]
    #
    def initialize(event, uuid_generator: Stenotype.config.uuid_generator)
      @event = event
      @uuid_generator = uuid_generator
    end

    #
    # @return {Hash} A hash representation of the event and its context
    #
    def serialize
      {
        **event_data,
        **event_options,
        **default_options,
        **eval_context_options
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
        handler = Stenotype::ContextHandlers.known.choose(handler_name: context_name)
        handler.new(context).as_json
      end.reduce(:merge!) || {}
    end

    def default_options
      {
        timestamp: Time.now.utc,
        uuid: uuid_generator.uuid
      }
    end
  end
end
