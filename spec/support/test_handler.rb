# frozen_string_literal: true

module FreshlyEvents
  class TestHandler < FreshlyEvents::ContextHandlers::Base
    self.handler_name = :klass

    def as_json(*_args)
      {}
    end
  end
end
