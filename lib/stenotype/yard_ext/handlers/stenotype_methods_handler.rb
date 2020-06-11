# frozen_string_literal: true

require_relative 'stenotype_methods/base'
require_relative 'stenotype_methods/emit_event'
require_relative 'stenotype_methods/emit_event_before'
require_relative 'stenotype_methods/emit_klass_event_before'
require_relative 'stenotype_methods/track_all_views'
require_relative 'stenotype_methods/track_view'
require_relative 'stenotype_methods/trackable_job'

class StenotypeMethodsHandler
  attr_reader :statement, :parser, :receiver, :method_name, :event_name, :args

  def initialize(parser, statement)
    @parser = parser
    @statement = statement
    @receiver, @method_name, @event_name, *@args = *statement
  end

  # event_name.loc.expression.source_buffer.name
  # event_name.loc.expression.source

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
  end

  # def register(object)
  #   return unless object.is_a?(::YARD::CodeObjects::Base)
  #   yield(object) if block_given?
  #   register_file_info(object)
  #   register_source(object)

  #   object
  # end

  # def register_file_info(object, file = parser.file, line = statement.loc.line)
  # end

  # def register_source(object, source = statement.loc.expression.source)
  #   return unless object.is_a?(YARD::CodeObjects::MethodObject)
  #   object.source ||= source
  # end

  # UnknownMethod = Class.new(ArgumentError)

  # TRACKED_INSTANCE_METHODS = %i{
  #   emit_event
  # }.freeze

  # TRACKED_KLASS_METHODS = %i{
  #   emit_event_before
  #   emit_klass_event_before
  #   track_view
  #   track_all_views
  #   trackable_job!
  # }.freeze

  # TRACKED_METHODS = [*TRACKED_INSTANCE_METHODS, *TRACKED_KLASS_METHODS].freeze

  # TRACKED_METHODS.each do |m|
  #   handles method_call(m)
  # end

  # process do
  #   # A registry to put all calls to emit_event into
  #   registry_object = StenotypeRegistryObject.new(:root, "Stenotype Events")

  #   # A separate namespace for each of the possible Stenotype methods emitting events
  #   # emit_event, emit_event_before, emit_klass_event_before
  #   emission_namespace = MethodRegistryObject.new(registry_object, method_name)

  #   # Upon each call to emit_event we creating a method object
  #   # and putting it into the registry. UUID is used to generate
  #   # a uniq name since namespace registry is a set, which only
  #   # contains uniq values as opposed to an array for example.
  #   method_object = YARD::CodeObjects::MethodObject.new(emission_namespace, SecureRandom.uuid, scope)

  #   # Pipe the method object through a list of processors
  #   method_object = method_handlers.inject(method_object) do |partial_result, handler|
  #     handler.new(statement, partial_result).process
  #   end

  #   # Register the method object to track source code, location and other attributes
  #   # as defined in the YARD::Handlers::Base#register method
  #   self.register(method_object)
  # end

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
