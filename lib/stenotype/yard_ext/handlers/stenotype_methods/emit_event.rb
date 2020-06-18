# frozen_string_literal: true

module Stenotype
  module YardExt
    module Handlers
      module StenotypeMethods
        class EmitEvent < Base
          def process(&block)
            return method_object unless applicable?

            # Try to figure out the CONTEXT_HANDLER in the param: { context_handler: { HANDLER_NAME: object } }
            method_object["handler_name"]              = infer_context_handler_name
            method_object["event_name"]                = event_name
            method_object["default_attributes_tag"]    = default_attributes_tag
            method_object["additional_attributes_tag"] = additional_attributes_tag if has_additional_attributes?

            yield method_object if block_given?

            method_object
          end

          def applicable?
            method_name.to_sym == :emit_event
          end

          private

          # First argument is the event name
          def event_name
            if [:sym, :str].include?(@event_name.type)
              name, *_ = *@event_name
              return name.to_s
            end

            # TODO: Mark that event name is dynamic
            method_object["dynamic_event_name"] = true
            return @event_name.loc.expression.source
          end

          def additional_attributes_tag
            # In case additional argument is a hash we can try to parse it
            if additional_attributes_param.type == :hash
              additional_attrs = *additional_attributes_param
              additional_attrs = additional_attrs.map do |key_value_pair|
                key, value = *key_value_pair
                key.loc.expression.source if key.type == :sym || key.type == :str
              end

              list = additional_attrs.compact.join("\n")

              section_name = "Additional Attributes"
              section_name += " NOTE: *Additional attributes contain dynamic keys. Please refer to the source code.*" unless additional_attrs.all?

              YARD::Tags::Tag.new(
                "context_handler_doc",
                list,
                [],
                section_name
              )
            end
          end

          def default_attributes_list
            # In case additional argument is a hash we can try to parse it
            if additional_attributes_param.type == :hash
            end
          end

          def has_additional_attributes?
            additional_attributes_param
          end

          # Second argument is the list of default attributes
          def additional_attributes_param
            args[0]
          end

          # Third argument is the evaluation context
          def eval_context_param
            args[1]
          end

          def infer_context_handler_name
            return unless eval_context_param # return if context arg is not present
            return unless eval_context_param.type == :hash

            pairs = *eval_context_param
            pairs.each do |hash_pair|
              key, value = *hash_pair
              if key.loc.expression.source == "eval_context"
                return unless value.type == :hash
                context_handler_hash = *value
                context_handler_hash.each do |handler_pair|
                  context_handler_name, context_handler_object = *handler_pair

                  return context_handler_name.loc.expression.source
                end
              end
            end
            # Looks scary but it is basically the code for going down the AST
            # eval_context_param. # { context_handler: { HANDLER_NAME: object } }
            # jump(:assoc)[1].    # { HANDLER_NAME: self }
            # jump(:assoc).       #   HANDLER_NAME: self
            # first.              #   HANDLER_NAME:
            # jump(:label).first  #   "HANDLER_NAME"
          end
        end
      end
    end
  end
end
