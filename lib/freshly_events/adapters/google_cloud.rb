# frozen_string_literal: true

require 'google/cloud/pubsub'

module FreshlyEvents
  module Adapters
    #
    # An adapter implementing method [#publish] to send data to Google Cloud PubSub
    #
    class GoogleCloud < Base
      #
      # @param event_data [Hash] The data to be published to Google Cloud
      # @raise [FreshlyEvents::Exceptions::GoogleCloudUnsupportedMode] unless the mode
      #   in configured to be :sync or :async
      # @raise [FreshlyEvents::Exceptions::MessageNotPublished] unless message is published
      #
      # rubocop:disable Metrics/MethodLength
      #
      def publish(event_data, **additional_arguments)
        case config.gc_mode
        when :async
          topic.publish_async(event_data, additional_arguments) do |result|
            raise FreshlyEvents::Exceptions::MessageNotPublished unless result.succeeded?
          end
        when :sync
          topic.publish(event_data, additional_arguments)
        else
          raise FreshlyEvents::Exceptions::GoogleCloudUnsupportedMode,
                'Please use either :sync or :async modes for publishing the events.'
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      #
      # @todo: r.kapitonov consider initializing the client once,
      # based on the adapter used in configuration (stdout, google cloud or other)
      #
      # :nocov:
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
      # :nocov:

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
