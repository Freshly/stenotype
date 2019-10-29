module FreshlyEvents
  module Frameworks
    #
    # @todo r.kapitonov Not a lucky name tho, consider changing to another name
    # @todo r.kapitonov Consider a way to track class methods invocation
    #
    # An extension for a plain Ruby class in order to track invocation of
    # instance methods.
    #
    module ObjectExt
      def self.extended(base) # @!visibility private
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
      def emit_event_before(*methods)
        proxy = const_get(:ObjectProxy)

        methods.each do |method|
          proxy.module_eval do
            define_method(method) do |*args, **rest_args, &block|
              FreshlyEvents::Event.emit!(
                { type: "class" },
                options: {
                  class: self.class.name,
                  method: __method__,
                },
                eval_context: { klass: self }
              )
              super(*args, **rest_args, &block)
            end
          end

          self.send(:prepend, proxy)
        end
      end
    end
  end
end
