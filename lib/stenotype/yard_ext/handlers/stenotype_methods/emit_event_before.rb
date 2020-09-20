# frozen_string_literal: true

module Stenotype
  module YardExt
    module Handlers
      module StenotypeMethods
        class EmitEventBefore < Base
          def process(&block)
            return method_object unless applicable?

            method_object["event_name"]             = event_name
            method_object["default_attributes_tag"] = default_attributes_tag

            yield method_object if block_given?

            method_object
          end

          def applicable?
            method_name.to_sym == :emit_event_before
          end

          private

          def default_attributes
            [:type, :class, :method]
          end

          def event_name
            :instance_method
          end
        end
      end
    end
  end
end
