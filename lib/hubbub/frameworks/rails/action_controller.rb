# frozen_string_literal: true

require 'active_support/concern'

module Hubbub
  module Frameworks
    module Rails
      #
      # An ActionController extension to be injected into classes
      # inheriting from [ActionController::Base]
      #
      module ActionControllerExtension
        extend ActiveSupport::Concern

        #
        # Emits and event with given data
        # @param data {Hash} Data to be sent to targets
        #
        def record_freshly_event(data)
          Hubbub::Event.emit!(data, options: {}, eval_context: { controller: self })
        end

        #
        # Class methods to be injected into classes
        # inherited from [ActionController::Base]
        #
        module ClassMethods
          # Adds a before_action to each action from the passed list. A before action
          # is emitting a {Hubbub::Event}. Please note that in case track_view is
          # used several times, it will keep track of the actions which emit events.
          # Each time a new track_view is called it will find a symmetric difference
          # of two sets: set of 'used' actions and a set passed to `track_view`.
          #
          # @example
          #   class MyController < ActionController::Base
          #     track_view :index, :show
          #
          #     def index
          #       # do_something
          #     end
          #
          #     def show
          #       # do something
          #     end
          #
          #     # Not covered by track_view
          #     def update
          #       # do something
          #     end
          #   end
          #
          # @param actions {Array<Symbol>} a list of tracked controller actions
          #
          def track_view(*actions)
            # A symmetric difference of two sets.
            # This prevents accidental duplicating of events
            delta = (_tracked_actions - Set[*actions]) | (Set[*actions] - _tracked_actions)

            return if delta.empty?

            before_action only: delta do
              record_freshly_event(type: 'view')
            end

            _tracked_actions.merge(delta)
          end

          # :nodoc:
          def _tracked_actions
            @_tracked_actions ||= Set.new
          end

          # Note this action will only define a symmetric difference of
          # the covered with events actions and the ones not used yet.
          # @see #track_view
          #
          # @example
          #   class MyController < ActionController::Base
          #     track_all_views
          #
          #     def index
          #       # do_something
          #     end
          #
          #     def show
          #       # do something
          #     end
          #   end
          #
          def track_all_views
            actions = self.action_methods

            # A symmetric difference of two sets.
            # This prevents accidental duplicating of events
            delta = ((_tracked_actions - actions) | (actions - _tracked_actions))

            return if delta.empty?

            before_action only: delta.to_a do
              record_freshly_event(type: 'view')
            end

            # merge is a mutating op
            _tracked_actions.merge(delta)
          end
        end
      end
    end
  end
end
