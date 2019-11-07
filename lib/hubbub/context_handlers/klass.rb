# frozen_string_literal: true

module Hubbub
  module ContextHandlers
    #
    # Plain Ruby class handler to support fetching data from a class
    #
    class Klass < Hubbub::ContextHandlers::Base
      self.handler_name = :klass

      #
      # @todo r.kapitonov Figure out the params
      # @return {Hash} a JSON representation of a Ruby class
      #
      def as_json(*_args)
        {}
      end
    end
  end
end
