module FreshlyEvents
  class TestHandler < FreshlyEvents::ContextHandlers::Base
    self.handler_name = :klass

    def as_json(*args)
      {}
    end
  end
end
