# frozen_string_literal: true

require 'securerandom'

module Stenotype
  #
  # A module containing freshly-event gem configuration
  #
  # @example Configuring the library
  #   Stenotype::Configuration.configure do |config|
  #     config.targets = [Target1.new, Target2.new]
  #     config.uuid_generator = SecureRandom
  #
  #     config.google_cloud do |gc|
  #       gc.credentials = 'abc'
  #       gc.project_id  = 'project'
  #       gc.topic       = '42'
  #       gc.mode        = :async
  #     end
  #
  #     config.rails do |rc|
  #       rc.enable_action_controller_ext = true
  #       rc.enable_active_job_ext        =  false
  #     end
  #   end
  #
  module Configuration
    extend Spicerack::Configurable

    # @!attribute targets
    # @return {Array<#publish>} a list of targets responding to method [#publish]

    # @!attribute [rw] dispatcher
    # @return {#publish} as object responding to method [#publish]

    # @!attribute [rw] uuid_generator
    # @return {#uuid} an object responding to method [#uuid]

    # @!attribute [rw] google_cloud
    # @return [NestedConfiguration] google cloud configuration.

    # @!attribute [rw] google_cloud.credentials
    # @return {String} a string with GC API credential. Refer to GC PubSub documentation

    # @!attribute [rw] google_cloud.project_id
    # @return {String} a name of the project in GC PubSub

    # @!attribute [rw] google_cloud.topic
    # @return {String} a name of the topic in GC PubSub

    # @!attribute [rw] google_cloud.mode
    # @return [:sync, :async] GC publish mode


    # @!attribute [rw] rails
    # @return [NestedConfiguration] Rails configuration.

    # @!attribute [rw] rails.enable_action_controller_ext
    # @return [true, false] A flag of whether ActionController ext is enabled

    # @!attribute [rw] rails.enable_active_job_ext
    # @return [true, false] A flag of whether ActiveJob ext is enabled

    configuration_options do
      option :targets, default: []
      option :dispatcher
      option :uuid_generator, default: SecureRandom

      nested :google_cloud do
        option :credentials
        option :project_id
        option :topic
        option :mode
      end

      nested :rails do
        option :enable_action_controller_ext, default: true
        option :enable_active_job_ext, default: true
      end
    end

    module_function

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
      if config.targets.nil? || config.targets.empty?
        raise Stenotype::Errors::NoTargetsSpecified,
              'Please configure a target(s) for events to be sent to. ' \
              'See Stenotype::Configuration for reference.'
      else
        config.targets
      end
    end
  end
end
