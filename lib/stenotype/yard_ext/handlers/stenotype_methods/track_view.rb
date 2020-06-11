# frozen_string_literal: true

module Handlers
  module StenotypeMethods
    class TrackView < Base
      def process(&block)
        return method_object unless applicable?

        method_object["event_name"]             = event_name
        method_object["default_attributes_tag"] = default_attributes_tag

        yield method_object if block_given?

        method_object
      end

      def applicable?
        method_name.to_sym == :track_view
      end

      private

      def default_attributes
        [:type, :class, :method, :url, :referer, :params, :ip]
      end

      def event_name
        :view
      end
    end
  end
end
