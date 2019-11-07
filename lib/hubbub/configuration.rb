# frozen_string_literal: true

module Hubbub
  #
  # A module containing freshly-event gem configuration
  #
  module Configuration
    class << self
      attr_writer :targets
      attr_accessor :gc_credentials
      attr_accessor :gc_project_id
      attr_accessor :gc_topic
      attr_accessor :gc_mode

      attr_accessor :dispatcher

      #
      # Yields control to the caller
      #
      # @return {Hubbub::Configuration}
      #
      def configure
        yield self
        self
      end

      #
      # @raise {Hubbub::Exceptions::NoTargetsSpecified} in case no targets are configured
      # @return {Array<#publish>} An array of targets implementing method [#publish]
      #
      def targets
        if @targets.nil? || @targets.empty?
          raise Hubbub::Exceptions::NoTargetsSpecified,
                'Please configure a target(s) for events to be sent to. ' \
                'See Hubbub::Configuration for reference.'
        else
          @targets
        end
      end
    end
  end
end
