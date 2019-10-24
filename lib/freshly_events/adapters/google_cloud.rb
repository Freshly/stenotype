require "google/cloud/pubsub"

module FreshlyEvents
  module Adapters
    class GoogleCloud < BaseAdapter
      def publish(*event_data)
        if config.gc_mode == :async
          topic.publish_async(*event_data) do |result|
            raise FreshlyEvents::Exceptions::MessageNotPublished unless result.succeeded?
          end
        else
          topic.publish(*event_data)
        end
      end

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
