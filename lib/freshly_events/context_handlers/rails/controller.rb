module FreshlyEvents
  module ContextHandlers
    module Rails
      class Controller < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :controller

        def as_json(*args)
          {
            class: request.controller_class.name,
            method: request.method,
            url: request.url,
            referer: request.referer,
            params: request.params.except("controller", "action"),
            ip: request.remote_ip,
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
