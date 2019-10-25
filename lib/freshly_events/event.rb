# sample:
# Event.new(:context [User, Admin], :class_context (Controller)).emit(:thing)
module FreshlyEvents
  class Event
    def self.emit!(name, options: {}, eval_context: {})
      self.new(name, options: options, eval_context: eval_context).emit!
    end

    attr_reader :name, :options, :eval_context

    def initialize(name, options: {}, eval_context: {})
      @name = name
      @options = options
      @eval_context = eval_context
    end

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
