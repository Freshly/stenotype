# frozen_string_literal: true

module FreshlyEvents
  module ContextHandlers
    #
    # Plain Ruby class handler to support fetching data from a class
    #
    class Klass < FreshlyEvents::ContextHandlers::Base
      self.handler_name = :klass

      #
      # @todo r.kapitonov Figure out the params
      # @return [Hash] a JSON representation of a Ruby class
      #
      def as_json(*args)
        {}
      end
    end
  end
end
