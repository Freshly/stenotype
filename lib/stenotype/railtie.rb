# frozen_string_literal: true

require "stenotype/frameworks/rails/action_controller"
require "stenotype/frameworks/rails/active_job"

module Stenotype
  #
  # A Railtie allowing to extend Rails component with
  #   Stenotype extensions for emitting event in various Rails components.
  #
  class Railtie < ::Rails::Railtie
    config.stenotype = Stenotype.config

    config.after_initialize { config.stenotype.targets.each(&:auto_initialize!) } if config.stenotype.rails.auto_adapter_initialization

    if config.stenotype.rails.enable_action_controller_ext
      ActiveSupport.on_load(:action_controller) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::Controller
        include Stenotype::Frameworks::Rails::ActionControllerExtension
      end
    end

    # @todo: consider using `::ActiveJob::Base.around_perform`
    #        or `::ActiveJob::Base.around_enqueue`
    if config.stenotype.rails.enable_active_job_ext
      ActiveSupport.on_load(:active_job) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::ActiveJob
        extend Stenotype::Frameworks::Rails::ActiveJobExtension
      end
    end

    rake_tasks do
      load 'tasks/document_events.rake'
    end
  end
end
