module FreshlyEvents
  module ContextHandlers
    module Rails
      class ActiveJob < FreshlyEvents::ContextHandlers::Base
        self.handler_name = :active_job

        def as_json(*args)
          {
            # TODO: r.kapitonov do we need other data?
            # params?
            # enqueued_at?
            job_id: job_id,
            queue_name: queue_name,
            class: context.class.name,
          }
        end

        private

        def job_id
          context.job_id
        end

        def queue_name
          context.queue_name
        end
      end
    end
  end
end
