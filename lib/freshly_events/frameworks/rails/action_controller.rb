require 'active_support/concern'

module FreshlyEvents
  module Frameworks
    module Rails
      module ActionControllerExtension
        extend ActiveSupport::Concern

        def record_freshly_event(name)
          FreshlyEvents::Event.emit!("#{name}", options: {}, eval_context: { controller: self })
        end

        module ClassMethods
          def track_event(name, actions: [])
            self.before_action only: actions do
              record_freshly_event name
            end
          end
        end
      end
    end
  end
end
