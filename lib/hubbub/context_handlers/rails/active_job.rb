# frozen_string_literal: true

module Hubbub
  module ContextHandlers
    #
    # A namespace containing extension of rails components
    # for fetching specific data from those components.
    # For example fetching request from a controller context,
    # or fetching ActiveJob attributes from an ActiveJob instance
    #
    module Rails
      #
      # ActiveJob handler to support fetching data out of an ActiveJob instance
      #
      class ActiveJob < Hubbub::ContextHandlers::Base
        self.handler_name = :active_job

        #
        # @todo: r.kapitonov how to deal with _args? It won't necessarily respond to #as_json
        # @return {Hash} a JSON representation of job's data
        #
        def as_json(*_args)
          {
            job_id: job_id,
            enqueued_at: Time.now,
            queue_name: queue_name,
            class: context.class.name
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
