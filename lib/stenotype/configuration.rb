# frozen_string_literal: true

module Stenotype
  #
  # A module containing freshly-event gem configuration
  #
  module Configuration
    class << self
      # @return {Array<#publish>} a list of targets responding to method [#publish]
      attr_writer :targets
      # @return {Sting} a string with GC API credential. Refer to GC PubSub documentation
      attr_accessor :gc_credentials
      # @return {String} a name of the project in GC PubSub
      attr_accessor :gc_project_id
      # @return {String} a name of the topic in GC PubSub
      attr_accessor :gc_topic
      # @return [:sync, :async] GC publish mode
      attr_accessor :gc_mode
      # @return {#publish} as object responding to method [#publish]
      attr_accessor :dispatcher
      # @return {#uuid} an object responding to method [#uuid]
      attr_accessor :uuid_generator
      # @return [true, false] A flag of whether ActionController ext is enabled
      attr_accessor :enable_action_controller_extension
      # @return [true, false] A flag of whether ActiveJob ext is enabled
      attr_accessor :enable_active_job_extension

      #
      # Yields control to the caller
      # @example Changing some of the config options
      #   Stenotype::Configuration.configure do |config|
      #     config.gc_mode = :sync
      #     config.uuid_generator = CustomUUIDGenerator
      #     # some other config options
      #   end
      #
      # @yield {Stenotype::Configuration}
      # @return {Stenotype::Configuration}
      #
      def configure
        yield self
        self
      end

      #
      # @example When at least one target is present
      #   Stenotype::Configuration.configure do |config|
      #     config.targets = [Target1.new, Target2.new]
      #   end
      #   Stenotype::Configuration.targets #=> [target_obj1, target_obj2]
      #
      # @example When no targets have been configured
      #   Stenotype::Configuration.configure { |config| config.targets = [] }
      #   Stenotype::Configuration.targets #=> Stenotype::Errors::NoTargetsSpecified
      #
      # @raise {Stenotype::Errors::NoTargetsSpecified} in case no targets are configured
      # @return {Array<#publish>} An array of targets implementing method [#publish]
      #
      def targets
        if @targets.nil? || @targets.empty?
          raise Stenotype::Errors::NoTargetsSpecified,
                'Please configure a target(s) for events to be sent to. ' \
                'See Stenotype::Configuration for reference.'
        else
          @targets
        end
      end
    end
  end
end
