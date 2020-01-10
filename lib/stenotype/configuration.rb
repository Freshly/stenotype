# frozen_string_literal: true

module Stenotype
  #
  # A module containing freshly-event gem configuration
  #
  # @example Configuring the library
  #   Stenotype.configure do |config|
  #     config.enabled = true
  #     config.targets = [Target1.new, Target2.new]
  #     config.uuid_generator = SecureRandom
  #
  #     config.google_cloud do |gc|
  #       gc.credentials = "abc"
  #       gc.project_id  = "project"
  #       gc.topic       = "42"
  #       gc.async       = true
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

    # @!attribute graceful_error_handling
    # @return {true, false} a flag for suppressing error raised withing the gem

    # @!attribute logger
    # @return {Logger} a logger with default severity methods to output gem level messages

    # @!attribute enabled
    # @return {true, false} a flag indicating whether event emission is enabled

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

    # @!attribute [rw] google_cloud.async
    # @return [true, false] GC publish mode, either async if true, sync if false


    # @!attribute [rw] rails
    # @return [NestedConfiguration] Rails configuration.

    # @!attribute [rw] rails.enable_action_controller_ext
    # @return [true, false] A flag of whether ActionController ext is enabled

    # @!attribute [rw] rails.enable_active_job_ext
    # @return [true, false] A flag of whether ActiveJob ext is enabled

    configuration_options do
      option :graceful_error_handling, default: true
      option :enabled, default: true
      option :targets, default: []
      option :dispatcher, default: Stenotype::Dispatcher
      option :uuid_generator, default: SecureRandom
      option :logger

      nested :google_cloud do
        option :credentials, default: nil
        option :project_id, default: nil
        option :topic, default: nil
        option :async, default: true
      end

      nested :rails do
        option :enable_action_controller_ext, default: true
        option :enable_active_job_ext, default: true
      end
    end

    module_function

    #
    # @example With default logger
    #   Stenotype.configure do |config|
    #     # config.logger = nil # logger not set manually
    #   end
    #   Stenotype.config.logger #=> `Logger.new(STDOUT)` instance
    #
    # @example With custom logger
    #   Stenotype.configure do |config|
    #     config.logger = custom_logger_instance
    #   end
    #   Stenotype.config.logger #=> custom_logger_instance
    #
    # @return [{Logger, CustomLogger}] a logger object. Logger.new(STDOUT) by
    #   default if another is not set during configuration
    #
    def logger
      return config.logger if config.logger
      config.logger || Logger.new(STDOUT)
    end

    #
    # @example When at least one target is present
    #   Stenotype.configure do |config|
    #     config.targets = [Target1.new, Target2.new]
    #   end
    #   Stenotype.config.targets #=> [target_obj1, target_obj2]
    #
    # @example When no targets have been configured
    #   Stenotype.configure { |config| config.targets = [] }
    #   Stenotype.config.targets #=> Stenotype::NoTargetsSpecifiedError
    #
    # @raise {Stenotype::NoTargetsSpecifiedError} in case no targets are configured
    # @return {Array<#publish>} An array of targets implementing method [#publish]
    #
    # @todo THIS NEVER GETS CALLED, needs a fix
    #
    def targets
      return config.targets unless config.targets.empty?

      raise Stenotype::NoTargetsSpecifiedError,
            "Please configure a target(s) for events to be sent to. "\
            "See #{Stenotype::Configuration} for reference."
    end
  end
end
