module FreshlyEvents
  module Exceptions
    #
    # This exception is being raised upon unsuccessful publishing of an event.
    #
    class MessageNotPublished < StandardError
    end
  end
end
