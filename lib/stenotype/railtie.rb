require "stenotype/frameworks/rails/action_controller"
require "stenotype/frameworks/rails/active_job"

module Stenotype
  #
  # A Railtie allowing to extend Rails component with
  #   Stenotype extensions for emitting event in various Rails components.
  #
  class Railtie < ::Rails::Railtie
    Stenotype.configure do |c|
      config.enable_action_controller_extension = true
      config.enable_active_job_extension = true
    end

    config.stenotype = Stenotype.config

    #
    # Register Rails handlers
    #
    Stenotype::ContextHandlers.module_eval do
      register Stenotype::ContextHandlers::Rails::Controller
      register Stenotype::ContextHandlers::Rails::ActiveJob
    end

    ActiveSupport.on_load(:action_controller) do
      include Stenotype::Frameworks::Rails::ActionControllerExtension
    end

    # @todo: consider using `::ActiveJob::Base.around_perform`
    #        or `::ActiveJob::Base.around_enqueue`
    ActiveSupport.on_load(:active_job) do
      extend Stenotype::Frameworks::Rails::ActiveJobExtension
    end
  end
end
