# frozen_string_literal: true

module Hubbub
  class TestHandler < Hubbub::ContextHandlers::Base
    self.handler_name = :klass

    def as_json(*_args)
      {}
    end
  end
end
