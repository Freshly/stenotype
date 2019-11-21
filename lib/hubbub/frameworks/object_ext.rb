# frozen_string_literal: true

module Hubbub
  #
  # A namespace containing extensions of various frameworks.
  # For example Rails components could be extended
  #
  module Frameworks
    #
    # An extension for a plain Ruby class in order to track invocation of
    # instance methods.
    #
    module ObjectExt
      #
      # Class methods for `Object` to be extended by
      #
      ClassMethodsExtension = Class.new(Module)
      #
      # Instance methods to be included into `Object` ancestors chain
      #
      InstanceMethodsExtension = Class.new(Module)

      attr_reader :instance_mod,
                  :class_mod

      # @!visibility private
      def self.included(klass)
        @instance_mod = InstanceMethodsExtension.new
        @class_mod = ClassMethodsExtension.new

        build_instance_methods
        build_class_methods

        klass.const_set(:InstanceProxy, Module.new)
        klass.const_set(:ClassProxy, Module.new)

        klass.send(:include, instance_mod)
        klass.extend(class_mod)

        super
      end

      #
      # @!method emit_event(data = {}, method: caller_locations.first.label, eval_context: nil)
      #   A method injected into all instances of Object
      # @!scope instance
      # @param data {Hash} Data to be sent to the targets
      # @param method {String} An optional method name
      # @param eval_context {Hash} A hash linking object to context handler
      # @return {Hubbub::Event} An instance of emitted event
      #

      #
      # @!method emit_event_before(*methods)
      #   A method injected into all instances of Object
      # @!scope instance
      # @param methods {Array<Symbol>} A list of method before which an event will be emitted
      #

      #
      # @!method emit_klass_event_before(*class_methods)
      #   A class method injected into all subclasses of [Object]
      # @!scope class
      # @param class_method {Array<Symbol>} A list of class method before which
      #   an event will be emitted
      #

      #
      # rubocop:disable Metrics/MethodLength
      # Adds two methods: [#emit_event] and [#emit_event_before] to every object
      #   inherited from [Object]
      #
      def build_instance_methods
        instance_mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def emit_event(data = {}, method: caller_locations.first.label, eval_context: nil)
            Hubbub::Event.emit!(
              {
                type: 'class_instance',
                **data,
              },
              options: {
                class: self.class.name,
                method: method.to_sym
              },
              eval_context: (eval_context || { klass: self })
            )
          end

          def emit_event_before(*methods)
            proxy = const_get(:InstanceProxy)

            methods.each do |method|
              proxy.module_eval do
                define_method(method) do |*args, **rest_args, &block|
                  Hubbub::Event.emit!(
                    { type: 'class_instance' },
                    options: {
                      class: self.class.name,
                      method: __method__
                    },
                    eval_context: { klass: self }
                  )
                  super(*args, **rest_args, &block)
                end
              end
            end

            send(:prepend, proxy)
          end
        RUBY
      end

      #
      # Adds class method [#emit_klass_event_before] to every class
      #   inherited from [Object]
      #
      def build_class_methods
        class_mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def emit_klass_event_before(*class_methods)
            proxy = const_get(:ClassProxy)

            class_methods.each do |method|
              proxy.module_eval do
                define_method(method) do |*args, **rest_args, &block|
                  Hubbub::Event.emit!(
                    { type: 'class' },
                    options: {
                      class: self.name,
                      method: __method__
                    },
                    eval_context: { klass: self }
                  )
                  super(*args, **rest_args, &block)
                end
              end

              singleton_class.send(:prepend, proxy)
            end
          end
        RUBY
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
