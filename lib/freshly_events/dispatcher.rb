# frozen_string_literal: true

module FreshlyEvents
  #
  # [FreshlyEvents::Dispatcher] is responsible for gluing together
  # publishing targets and data gathering.
  #
  class Dispatcher
    #
    # Publishes an event to the list of configured targets.
    #
    # @example
    #
    #   event = FreshlyEvents::Event.new(data, options, eval_context)
    #   FreshlyEvents::Dispatcher.new.publish(event)
    #
    # @param event [FreshlyEvents::Event] An instance of event to be published.
    # @param serializer [#serialize] A class responsible for serializing the event
    # @return [FreshlyEvent::Dispatcher] for the sake of chaining
    #
    def publish(event, serializer: FreshlyEvents::EventSerializer)
      event_data = serializer.new(event).serialize

      targets.each do |t|
        t.publish(event_data)
      end

      self
    end

    private

    def targets
      @targets ||= FreshlyEvents.config.targets
    end
  end
end
