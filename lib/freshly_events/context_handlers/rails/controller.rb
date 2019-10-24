module FreshlyEvents
  module ContextHandlers
    module Rails
      class Controller < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :controller

        def as_json(*args)
          # TODO
        end

        private

        def fetch_requets
          # do something
        end
      end
    end
  end
end
