module FreshlyEvents
  class Dispatcher
    def publish(event)
      targets.each do |t|
        t.publish(event.name, event.options.merge(default_options))
      end
    end

    private

    def targets
      @targets ||= FreshlyEvents.config.targets
    end

    def default_options
      { timestamp: Time.now.utc }
    end
  end
end
