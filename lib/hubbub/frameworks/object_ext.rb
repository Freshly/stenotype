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
      # Class methods for {Object} to be extended by
      #
      ClassMethodsExtension = Class.new(Module)
      #
      # Instance methods to be included into {Object} ancestors chain
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
      # rubocop:disable Metrics/MethodLength
      # @!visibility private
      #
      def build_instance_methods
        instance_mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
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

              send(:prepend, proxy)
            end
          end
        RUBY
      end

      #
      # @!visibility private
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
