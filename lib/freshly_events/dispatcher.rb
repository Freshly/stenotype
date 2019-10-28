module FreshlyEvents
  ##
  # [FreshlyEvents::Dispatcher] is responsible for gluing together
  # publishing targets and data gathering.
  #
  class Dispatcher
    ##
    # Publishes an event to the list of configured targets.
    #
    # @example
    #
    #   event = FreshlyEvents::Event.new(data, options, eval_context)
    #   FreshlyEvents::Dispatcher.new.publish(event)
    #
    # @param event [FreshlyEvents::Event] An instance of event to be published.
    #
    # @return [FreshlyEvent::Dispatcher] for the sake of chaining
    #
    def publish(event)
      event_data = {
        **event.options,
        **default_options,
        **eval_context_options(event.eval_context),
      }

      targets.each do |t|
        t.publish(event.data, event_data)
      end

      self
    end

    private

    def targets
      @targets ||= FreshlyEvents.config.targets
    end

    def eval_context_options(eval_context)
      result = eval_context.map do |context_name, context|
        handler = FreshlyEvents::ContextHandlers.known.choose(handler_name: context_name)
        handler.new(context).as_json
      end.reduce(:merge!) || {}

      result
    end

    def default_options
      { timestamp: Time.now.utc }
    end
  end
end
