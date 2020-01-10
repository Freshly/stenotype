# frozen_string_literal: true

module Stenotype
  #
  # {Stenotype::Event} represents a triggered event
  #
  class Event
    #
    # Delegates event to instance of {Stenotype::Event}.
    #
    # @example Emit an event using class method
    #   Stenotype::Event.emit!(data, options, eval_context)
    #
    # @param {[String, Symbol]} name Event name.
    # @param {Hash} attributes Data to be published to the targets.
    # @param {Hash} eval_context A context having handler defined in {Stenotype::ContextHandlers}.
    # @param dispatcher {#publish} A dispatcher object responding to [#publish].
    # @return {Stenotype::Event} An instance of {Stenotype::Event}
    #
    def self.emit!(name, attributes = {}, eval_context: {}, dispatcher: Stenotype.config.dispatcher)
      return unless Stenotype.config.enabled

      begin
        event = new(name, attributes, eval_context: eval_context, dispatcher: dispatcher)
        event.emit!
        event
      rescue => error
        #
        # @todo This is a temporary solution to enable conditional logger fetching
        #   needs a fix to use default Spicerack::Configuration functionality
        #
        Stenotype::Configuration.logger.error(error)

        raise unless Stenotype.config.graceful_error_handling
      end
    end

    attr_reader :name, :attributes, :eval_context, :dispatcher

    #
    # @example Create an event
    #   event = Stenotype::Event.new(data, options, eval_context)
    # @example Create an event with custom dispatcher
    #   event = Stenotype::Event.new(data, options, eval_context, dispatcher: MyDispatcher.new)
    #
    # @param {[String, Symbol]} name Event name.
    # @param {Hash} attributes Data to be published to the targets.
    # @param {Hash} eval_context A context having handler defined in {Stenotype::ContextHandlers}.
    # @param dispatcher {#publish} A dispatcher object responding to [#publish].
    # @return {Stenotype::Event} An instance of event
    #
    def initialize(name, attributes = {}, eval_context: {}, dispatcher: Stenotype.config.dispatcher)
      @name = name
      @attributes = attributes
      @eval_context = eval_context
      @dispatcher = dispatcher.new
    end

    #
    # Emits a {Stenotype::Event}.
    #
    # @example Emit an instance of event
    #   event = Stenotype::Event.new('events_name', { key: :value }, eval_context: { controller: ctrl })
    #   event.emit! #=> Publishes the event to targets
    #
    def emit!
      return unless Stenotype.config.enabled

      begin
        dispatcher.publish(self)
      rescue => error
        #
        # @todo This is a temporary solution to enable conditional logger fetching
        #   needs a fix to use default Spicerack::Configuration functionality
        #
        Stenotype::Configuration.logger.error(error)

        raise unless Stenotype.config.graceful_error_handling
      end
    end
  end
end
