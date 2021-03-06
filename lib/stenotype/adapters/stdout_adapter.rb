# frozen_string_literal: true

module Stenotype
  module Adapters
    #
    # An adapter implementing method {#publish} to send data to STDOUT
    #
    # @example
    #   class SomeClassWithEvents
    #     def method_emitting_enent
    #       result_of_calculations = collect_some_data
    #       # This will print the data to STDOUT by default
    #       stdout_adapter.publish(result_of_calculation, additional: :data, more: :data)
    #       result_of_calculations
    #     end
    #
    #     def stdout_adapter
    #       Stenotype::Adapters::StdoutAdapter.new
    #     end
    #   end
    #
    class StdoutAdapter < Base
      #
      # @param event_data {Sting} The data to be published to STDOUT
      #
      # @example Publishing to default client (STDOUT)
      #  adapter = Stenotype::Adapters::StdoutAdapter.new
      #  adapter.publish({ event: :data }, { additional: :data })
      #
      # @example Publishing to custom client (STDERR)
      #  adapter = Stenotype::Adapters::StdoutAdapter.new(client: STDERR)
      #  adapter.publish({ event: :data }, { additional: :data })
      #
      def publish(event_data, **additional_attrs)
        client.info("[Stenotype::Event] emitted with the following attributes") do
          "MESSAGE BODY: #{event_data}, MESSAGE ATTRIBUTES #{additional_attrs.to_json}"
        end
      end

      #
      # Does nothing
      #
      def flush!
        # noop
      end

      private

      def client
        @client ||= (config.logger || Logger.new(STDOUT))
      end

      def config
        Stenotype.config
      end
    end
  end
end
