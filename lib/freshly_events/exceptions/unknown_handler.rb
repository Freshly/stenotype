module FreshlyEvents
  module Exceptions
    #
    # This exception is being raised upon using a context handler which
    # has never been registered in known handlers.
    #
    class UnkownHandler < StadardError
    end
  end
end
