require 'active_support/concern'

module FreshlyEvents
  module Frameworks
    module Rails
      module ActionControllerExtension
        extend ActiveSupport::Concern

        def record_freshly_event(data)
          FreshlyEvents::Event.emit!(data, options: {}, eval_context: { controller: self })
        end

        module ClassMethods
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
