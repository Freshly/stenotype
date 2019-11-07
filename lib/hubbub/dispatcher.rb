# frozen_string_literal: true

module Hubbub
  #
  # [Hubbub::Dispatcher] is responsible for gluing together
  # publishing targets and data gathering.
  #
  class Dispatcher
    #
    # Publishes an event to the list of configured targets.
    #
    # @example
    #
    #   event = Hubbub::Event.new(data, options, eval_context)
    #   Hubbub::Dispatcher.new.publish(event)
    #
    # @param event {Hubbub::Event} An instance of event to be published.
    # @param serializer {#serialize} A class responsible for serializing the event
    # @return {FreshlyEvent::Dispatcher} for the sake of chaining
    #
    def publish(event, serializer: Hubbub::EventSerializer)
      event_data = serializer.new(event).serialize

      targets.each do |t|
        t.publish(event_data)
      end

      self
    end

    private

    def targets
      Hubbub.config.targets
    end
  end
end
