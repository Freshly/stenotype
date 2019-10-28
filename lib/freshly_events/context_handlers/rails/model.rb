module FreshlyEvents
  module ContextHandlers
    module Rails
      # TODO: r.kapitonov do we need this really?
      class Model < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :model

        def as_json(*args)
          # TODO: r.kapitonov
        end

        private

        def fetch_table_name
          # TODO: r.kapitonov
        end
      end
    end
  end
end
