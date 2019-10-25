module FreshlyEvents
  module ContextHandlers
    module Rails
      class Model < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :model

        def as_json(*args)
          # TODO
        end

        private

        def fetch_table_name
          # do something
        end
      end
    end
  end
end
