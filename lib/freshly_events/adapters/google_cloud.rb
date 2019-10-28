require "google/cloud/pubsub"

module FreshlyEvents
  module Adapters
    # An adapter implementing method [#publish] to send data to Google Cloud PubSub
    #
    class GoogleCloud < Base
      # @param event_data [Hash] The data to be published to Google Cloud
      # @raise [FreshlyEvents::Exceptions::GoogleCloudUnsupportedMode] unless the mode in configured to be :sync or :async
      # @raise [FreshlyEvents::Exceptions::MessageNotPublished] unless message is published
      def publish(*event_data)
        final_data = event_data.reduce({}, :merge)

        case config.gc_mode
        when :async
          topic.publish_async(final_data.as_json) do |result|
            raise FreshlyEvents::Exceptions::MessageNotPublished unless result.succeeded?
          end
        when :sync
          # @todo: r.kapitonov this will only work in Rails environment
          # since as_json is not defined in plain ruby unless a third party
          # core ext is used.
          topic.publish(final_data.as_json)
        else
          raise FreshlyEvents::Exceptions::GoogleCloudUnsupportedMode
        end
      end

      private

      # @todo: r.kapitonov consider initializing the client once,
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
      # @todo: r.kapitonov consider initializing a topic during gem load
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
