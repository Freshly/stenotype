# frozen_string_literal: true

require_relative 'stenotype_methods/base'
require_relative 'stenotype_methods/emit_event'
require_relative 'stenotype_methods/emit_event_before'
require_relative 'stenotype_methods/emit_klass_event_before'
require_relative 'stenotype_methods/track_all_views'
require_relative 'stenotype_methods/track_view'
require_relative 'stenotype_methods/trackable_job'

module Stenotype
  module YardExt
    module Handlers
      class StenotypeMethodsHandler
        attr_reader :statement, :parser, :receiver, :method_name, :event_name, :args

        def initialize(parser, statement)
          @parser = parser
          @statement = statement
          @receiver, @method_name, @event_name, *@args = *statement
        end

        def process
          # A registry to put all calls to emit_event into
          registry_object = StenotypeRegistryObject.new(:root, "Stenotype Events")

          # A separate namespace for each of the possible Stenotype methods emitting events
          # emit_event, emit_event_before, emit_klass_event_before
          emission_namespace = MethodRegistryObject.new(registry_object, method_name)

          # Upon each call to emit_event we creating a method object
          # and putting it into the registry. UUID is used to generate
          # a uniq name since namespace registry is a set, which only
          # contains uniq values as opposed to an array for example.
          method_object = YARD::CodeObjects::MethodObject.new(emission_namespace, SecureRandom.uuid)

          # Pipe the method object through a list of processors
          method_object = method_handlers.inject(method_object) do |partial_result, handler|
            handler.new(statement, partial_result).process
          end

          # Register the method object to track source code, location and other attributes
          # similar to as it is defined in the YARD::Handlers::Base#register method
          method_object.add_file(parser.file, statement.loc.line, false)
          method_object.source ||= statement.loc.expression.source

          method_object[:dynamic_event_name] = dynamic_event_name?
        end

        def dynamic_event_name?
          ![:sym, :str].include?(event_name.type)
        end

        # A separate handler for each stenotype dsl method
        def method_handlers
          [
            Handlers::StenotypeMethods::EmitEvent,
            Handlers::StenotypeMethods::EmitEventBefore,
            Handlers::StenotypeMethods::EmitKlassEventBefore,
            Handlers::StenotypeMethods::TrackAllViews,
            Handlers::StenotypeMethods::TrackView,
            Handlers::StenotypeMethods::TrackableJob,
          ]
        end
      end
    end
  end
end
