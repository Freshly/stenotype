# frozen_string_literal: true

require "spec_helper"
module Stenotype
  module Test
    module Matchers
      extend RSpec::Matchers::DSL

      class DiffSizeMatchesExpectation
        attr_reader :matching_events, :expected_count

        def initialize(matching_events, expected_count)
          @matching_events = matching_events
          @expected_count = expected_count
        end

        def failure_message
          "expected to see #{expected_count} event(s) but got #{matching_events.count} event(s)."
        end

        def matches?
          matching_events.count == expected_count
        end
      end

      class EventHasExpectedArguments
        attr_reader :matching_events, :expected_arguments

        def initialize(matching_events, expected_arguments)
          @matching_events = matching_events
          @expected_arguments = stringify_keys(expected_arguments)
        end

        def matches?
          return false if multiple_events?

          (expected_arguments.to_a - matching_event.to_a).empty?
        end

        def failure_message
          if multiple_events?
            "more than one event with given event name has been emitted. Can not match event arguments"
          else
            "expected to see all attributes from #{expected_arguments} to be included in event attributes but got #{matching_event}"
          end
        end

        private

        def multiple_events?
          matching_events.size > 1
        end

        def matching_event
          matching_events.first
        end

        def stringify_keys(hash)
          hash.transform_keys(&:to_s)
        end
      end

      class EventEmitted
        attr_reader :matching_events, :expected_event_name

        def initialize(matching_events, expected_event_name)
          @matching_events = matching_events
          @expected_event_name = expected_event_name
        end

        def matches?
          matching_events.any?
        end

        def failure_message
          "expected to see a '#{expected_event_name}' event but got nothing"
        end
      end

      matcher :emit_an_event do |expected_event_name, *_|
        supports_block_expectations

        match do |emitting_event_block|
          @emitting_event_block = emitting_event_block

          partial_matchers << EventEmitted.new(matching_events, expected_event_name)
          partial_matchers << EventHasExpectedArguments.new(matching_events, @arguments_should_include) if should_validate_events_count?
          partial_matchers << DiffSizeMatchesExpectation.new(matching_events, @matching_events_count) if should_validate_attributes?

          return first_failure.nil?
        end

        chain(:with_arguments_including) { |**args| @arguments_should_include = args }
        chain(:exactly) { |times| @matching_events_count = times }

        # noop for syntatic sugar
        chain(:times) {}
        chain(:time) {}

        def matching_events
          @matching_events ||= begin
            buffer_before_emit = stenotype_event_buffer.dup
            @emitting_event_block.call
            buffer_after_emit = stenotype_event_buffer.dup

            diff = buffer_after_emit - buffer_before_emit
            diff.select { |event| event["name"] == expected_event_name.to_s }
          end
        end

        def partial_matchers
          @partial_matchers ||= []
        end

        def first_failure
          @first_failure ||= partial_matchers.detect { |matcher| !matcher.matches? }
        end

        failure_message do
          return super() unless first_failure

          first_failure.failure_message
        end

        private

        def should_validate_events_count?
          @matching_events_count.present?
        end

        def should_validate_attributes?
          @arguments_should_include.present?
        end

        def stenotype_event_buffer
          stenotype_event_target.buffer
        end

        def stenotype_event_target
          Stenotype.config.targets.first
        end
      end
    end
  end
end
