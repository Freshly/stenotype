# frozen_string_literal: true

require 'hubbub/adapters/base'

module Hubbub
  class TestAdapter < Hubbub::Adapters::Base
    attr_writer :buffer

    def initialize(buffer = [])
      @buffer = buffer
      super()
    end

    def publish(event_data)
      buffer << event_data
    end

    def buffer
      @buffer || raise(NotImplementedError,
                       'Please specify a buffer for test adapter')
    end
  end
end
