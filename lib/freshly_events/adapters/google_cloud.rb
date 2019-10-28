require "google/cloud/pubsub"

module FreshlyEvents
  module Adapters
    class GoogleCloud < Base
      def publish(*event_data)
        final_data = event_data.reduce({}, :merge)

        case config.gc_mode
        when :async
          topic.publish_async(final_data.as_json) do |result|
            raise FreshlyEvents::Exceptions::MessageNotPublished unless result.succeeded?
          end
        when :sync
          # TODO: r.kapitonov this will only work in Rails environment
          # since as_json is not defined in plain ruby unless a third party
          # core ext is used.
          topic.publish(final_data.as_json)
        else
          raise GoogleCloudUnsupportedMode
        end
      end

      # But that would stop the publisher, wouldn't than?
      #
      def flush_async_queue!
        topic.async_publisher.stop.wait!
      end

      private

      # TODO: r.kapitonov consider initializing the client once,
      # based on the adapter used in configuration (stdout, google cloud or other)
      #
      def client
        @client ||= Google::Cloud::PubSub.new(
          project_id: project_id,
          credentials: credentials
        )
      end

      def project_id
        config.gc_project_id
      end

      def credentials
        config.gc_credentials
      end

      # Use memoization, otherwise a new topic will be created
      # every time. And a new async_publisher will be created.
      #
      # TODO: r.kapitonov consider initializing a topic during gem load
      # similar to how dispatcher is instantiated.
      #
      def topic
        @topic ||= client.topic config.gc_topic
      end

      def config
        FreshlyEvents.config
      end
    end
  end
end
