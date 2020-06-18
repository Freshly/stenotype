# frozen_string_literal: true

module Stenotype
  module YardExt
    module Handlers
      module MethodsEnum
        TRACKED_INSTANCE_METHODS = %i{
          emit_event
        }.freeze

        TRACKED_KLASS_METHODS = %i{
          emit_event_before
          emit_klass_event_before
          track_view
          track_all_views
          trackable_job!
        }.freeze

        TRACKED_METHODS = [*TRACKED_INSTANCE_METHODS, *TRACKED_KLASS_METHODS].freeze

        module_function

        def tracked_methods
          TRACKED_METHODS
        end
      end
    end
  end
end
