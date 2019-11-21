# frozen_string_literal: true

require 'google/cloud/pubsub'

module Stenotype
  module Adapters
    #
    # An adapter implementing method {#publish} to send data to Google Cloud PubSub
    #
    class GoogleCloud < Base
      #
      # @param event_data {Hash} The data to be published to Google Cloud
      # @raise {Stenotype::Exceptions::GoogleCloudUnsupportedMode} unless the mode
      #   in configured to be :sync or :async
      # @raise {Stenotype::Exceptions::MessageNotPublished} unless message is published
      #
      # rubocop:disable Metrics/MethodLength
      #
      def publish(event_data, **additional_arguments)
        case config.gc_mode
        when :async
          topic.publish_async(event_data, additional_arguments) do |result|
            raise Stenotype::Exceptions::MessageNotPublished unless result.succeeded?
          end
        when :sync
          topic.publish(event_data, additional_arguments)
        else
          raise Stenotype::Exceptions::GoogleCloudUnsupportedMode,
                'Please use either :sync or :async modes for publishing the events.'
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      # :nocov:
      def client
        @client ||= Google::Cloud::PubSub.new(
          project_id: config.gc_project_id,
          credentials: config.gc_credentials
        )
      end

      # Use memoization, otherwise a new topic will be created
      # every time. And a new async_publisher will be created.
      # :nocov:
      def topic
        @topic ||= client.topic config.gc_topic
      end

      def config
        Stenotype.config
      end
    end
  end
end
