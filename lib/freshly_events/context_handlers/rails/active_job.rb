module FreshlyEvents
  module ContextHandlers
    module Rails
      class ActiveJob < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :active_job

        def as_json(*args)
          # TODO
        end

        private

        def fetch_job_id
          # do something
        end
      end
    end
  end
end
