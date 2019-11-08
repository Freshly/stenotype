# frozen_string_literal: true

module Hubbub
  #
  # A namespace containing extensions of various frameworks.
  # For example Rails components could be extended
  #
  module Frameworks
    #
    # @todo r.kapitonov Not a lucky name tho, consider changing to another name
    # @todo r.kapitonov Consider a way to track class methods invocation
    #
    # An extension for a plain Ruby class in order to track invocation of
    # instance methods.
    #
    module ObjectExt
      # @!visibility private
      def self.extended(base)
        base.const_set(:ObjectProxy, Module.new)
        super
      end

      #
      # @example:
      #   class PlainRubyClass
      #     # => will prepend a specified methods with event recorder
      #     emit_event_before :some_method, :another_method
      #
      #     def some_method(data)
      #       # do_something
      #     end
      #
      #     def another_method(args)
      #       # do_something
      #     end
      #   end
      #
      # rubocop:disable Metrics/MethodLength
      #
      def emit_event_before(*methods)
        proxy = const_get(:ObjectProxy)

        methods.each do |method|
          proxy.module_eval do
            define_method(method) do |*args, **rest_args, &block|
              Hubbub::Event.emit!(
                { type: 'class' },
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

      def emit_event(key, *data)
        Hubbub::Event.emit!(
            { type: 'event',
              name: key
            }.merge(data),
            eval_context: { klass: self }
        )
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
