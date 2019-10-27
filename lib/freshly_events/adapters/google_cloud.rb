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
          topic.publish(final_data.as_json)
        else
          raise GoogleCloudUnsupportedMode
        end
      end

      # But that would stop the publisher, wouldn't than?
      #
      def flush_async_queue!
        topic.acync_publisher.stop.wait!
      end

      private

      def client
        Google::Cloud::PubSub.new(
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

      def topic
        client.topic config.gc_topic
      end

      def config
        FreshlyEvents.config
      end
    end
  end
end
