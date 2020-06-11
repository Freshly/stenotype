# frozen_string_literal: true

module Handlers
  module StenotypeMethods
    class Base
      attr_reader :method_object,
                  :statement,
                  :receiver,
                  :method_name,
                  :event_name,
                  :args

      def initialize(statement, method_object)
        @statement = statement
        @receiver, @method_name, @event_name, *@args = *statement
        @method_object = method_object
      end

      def process(&block)
        raise NotImplementedError, "Must be implemented in subclasses"
      end

      private

      # The list of default attributes for an Event from Stenotype gem
      def default_attributes_tag
        YARD::Tags::Tag.new(
          "context_handler_doc",
          default_attributes.join("\n"),
          [],
          "Default Attributes"
        )
      end

      # This list is taken from Stenotype gem
      def default_attributes
        [:timestamp, :uuid]
      end

      def event_name
        raise NotImplementedError, "Must be implemented in subclasses"
      end

      def scope
        raise NotImplementedError, "Unknown scope"
      end
    end
  end
end
