# frozen_string_literal: true

module Handlers
  module StenotypeMethods
    class TrackableJob < Base
      def process(&block)
        return method_object unless applicable?

        method_object["event_name"]             = event_name
        method_object["default_attributes_tag"] = default_attributes_tag

        yield method_object if block_given?

        method_object
      end

      def applicable?
        method_name.to_sym == :trackable_job!
      end

      private

      def default_attributes
        [:type, :job_id, :enqueued_at, :queue_name, :class]
      end

      def event_name
        :todo
      end
    end
  end
end
