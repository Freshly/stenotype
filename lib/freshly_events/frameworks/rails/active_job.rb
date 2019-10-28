require 'active_support/concern'

module FreshlyEvents
  module Frameworks
    module Rails
      module ActiveJobExtension
        def self.extended(base)
          mod = base.const_set(:JobExt, Module.new)
          super
        end

        #
        # @example:
        #   class MyJob < ApplicationJob
        #     trackable_job! # => will prepend a perform action with event recorder
        #
        #     def perform(data)
        #       # do_something
        #     end
        #   end
        #
        # TODO: r.kapitonov perhaps consider using an alias method instead?
        #
        def trackable_job!
          mod = const_get(:JobExt)
          mod.module_eval do
            define_method(:perform) do |*args, **rest_args, &block|
              FreshlyEvents::Event.emit!(
                { type: "active_job" },
                options: {
                  enqueued_at: Time.now.utc,
                },
                eval_context: { active_job: self }
              )
              super(*args, **rest_args, &block)
            end
          end

          # Prepend an instance of module so that
          # super() can be chained down the ancestors
          # without changing existing ActiveJob interface
          #
          self.send(:prepend, mod)
        end
      end
    end
  end
end
