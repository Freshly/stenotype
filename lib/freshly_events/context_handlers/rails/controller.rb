module FreshlyEvents
  module ContextHandlers
    module Rails
      class Controller < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :controller

        def as_json(*args)
          {
            hey: "I'm fetching data from controller!",
            url: request.url
          }
        end

        private

        def request
          context.request
        end
      end
    end
  end
end
