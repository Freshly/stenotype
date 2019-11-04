# frozen_string_literal: true

require 'active_support/concern'

module FreshlyEvents
  module Frameworks
    module Rails
      #
      # An extension for ActiveJob to enable adding a hook
      # before performing an instance of ActiveJob
      #
      module ActiveJobExtension
        # @!visibility private
        def self.extended(base)
          base.const_set(:JobExt, Module.new)
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
        # @todo: r.kapitonov perhaps consider using an alias method instead?
        #
        # rubocop:disable Metrics/MethodLength
        #
        def trackable_job!
          proxy = const_get(:JobExt)
          proxy.module_eval do
            define_method(:perform) do |*args, **rest_args, &block|
              FreshlyEvents::Event.emit!(
                { type: 'active_job' },
                options: {},
                eval_context: { active_job: self }
              )
              super(*args, **rest_args, &block)
            end
          end

          # Prepend an instance of module so that
          # super() can be chained down the ancestors
          # without changing existing ActiveJob interface
          #
          send(:prepend, proxy)
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
