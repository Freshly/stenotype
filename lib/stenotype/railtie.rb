require "stenotype/frameworks/rails/action_controller"
require "stenotype/frameworks/rails/active_job"

module Stenotype
  #
  # A Railtie allowing to extend Rails component with
  #   Stenotype extensions for emitting event in various Rails components.
  #
  class Railtie < ::Rails::Railtie
    Stenotype.configure do |c|
      c.enable_action_controller_extension = true
      c.enable_active_job_extension = true
    end

    config.stenotype = Stenotype.config

    if config.stenotype.enable_action_controller_extension
      ActiveSupport.on_load(:action_controller) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::Controller
        include Stenotype::Frameworks::Rails::ActionControllerExtension
      end
    end

    # @todo: consider using `::ActiveJob::Base.around_perform`
    #        or `::ActiveJob::Base.around_enqueue`
    if config.stenotype.enable_active_job_extension
      ActiveSupport.on_load(:active_job) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::ActiveJob
        extend Stenotype::Frameworks::Rails::ActiveJobExtension
      end
    end
  end
end
