module FreshlyEvents
  class Dispatcher
    def publish(event)
      event_data = {
        **event.options,
        **default_options,
        **eval_context_options(event.eval_context),
      }

      targets.each do |t|
        t.publish(event.name, event_data)
      end
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
