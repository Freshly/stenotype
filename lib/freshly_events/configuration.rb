# frozen_string_literal: true

module FreshlyEvents
  module Configuration
    class << self
      attr_accessor :targets
      attr_accessor :gc_credentials
      attr_accessor :gc_project_id
      attr_accessor :gc_topic
      attr_accessor :gc_mode

      attr_accessor :dispatcher

      #
      # Yields control to the caller
      #
      # @return [FreshlyEvents::Configuration]
      #
      def configure
        yield self
        self
      end

      #
      # @raise [FreshlyEvents::Exceptions::NoTargetsSpecified] in case no targets are configured
      # @return [Array<#publish>] An array of targets implementing method [#publish]
      #
      def targets
        if @targets.nil? or @targets.empty?
          raise FreshlyEvents::Exceptions::NoTargetsSpecified,
            "Please configure a target(s) for events to be sent to. " +
            "See FreshlyEvents::Configuration for reference."
        else
          @targets
        end
      end
    end
  end
end
