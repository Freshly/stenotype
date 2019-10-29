module FreshlyEvents
  #
  # [FreshlyEvents::Event] represents a triggered event
  #
  class Event
    #
    # Delegates event to instance of [FreshlyEvents::Event].
    #
    # @example
    #
    #   FreshlyEvents::Event.emit!(data, options, eval_context)
    #
    # @param data [Hash] Data to be published to the targets.
    # @param options [Hash] A hash of additional options to be tracked.
    # @param eval_context [Hash] A context having handler defined in [FreshlyEvents::ContextHandlers].
    # @return {FreshlyEvent::Event} An instance of [FreshlyEvents::Event]
    #
    def self.emit!(data, options: {}, eval_context: {})
      event = new(data, options: options, eval_context: eval_context)
      event.emit!
      event
    end

    attr_reader :data, :options, :eval_context

    #
    # @example
    #
    #   FreshlyEvents::Event.emit!(data, options, eval_context)
    #
    # @param [Hash] data Data to be published to the targets.
    # @param [Hash] options A hash of additional options to be tracked.
    # @param [Hash] eval_context A context having handler defined in [FreshlyEvents::ContextHandlers].
    # @return [FreshlyEvent::Event] An instance of event
    #
    def initialize(data, options: {}, eval_context: {})
      @data = data
      @options = options
      @eval_context = eval_context
    end

    #
    # Emits a [FreshlyEvents::Event].
    #
    # @example
    #
    #   event = FreshlyEvents::Event.new(data, options, eval_context)
    #   event.emit!
    #
    def emit!
      dispatcher.publish(self)
    end

    private

    # Should we create an instance on each event?
    # because it seems like dispatcher has to have some sort of state
    def dispatcher
      FreshlyEvents.config.dispatcher
    end
  end
end
