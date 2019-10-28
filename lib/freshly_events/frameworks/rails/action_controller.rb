require 'active_support/concern'

module FreshlyEvents
  module Frameworks
    module Rails
      module ActionControllerExtension
        extend ActiveSupport::Concern

        #
        # Emits and event with given data
        # @param data [Hash] Data to be sent to targets
        #
        def record_freshly_event(data)
          FreshlyEvents::Event.emit!(data, options: {}, eval_context: { controller: self })
        end

        module ClassMethods
          # Adds a before_action to each action from the passed list. A before action
          # is emitting a FreshlyEvents::Event.
          #
          # @param actions [Array<Symbol>] a list of tracked controller actions
          #
          def track_view(actions: [])
            self.before_action only: actions do
              record_freshly_event({ type: "view" })
            end
          end
        end
      end
    end
  end
end
