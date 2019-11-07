# frozen_string_literal: true

module Hubbub
  #
  # A namespace for holding library-level exceptions.
  #
  module Exceptions
    #
    # This exception is being raised in case an unsupported mode
    # for Google Cloud is specified.
    #
    class GoogleCloudUnsupportedMode < StandardError; end

    #
    # This exception is being raised upon unsuccessful publishing of an event.
    #
    class MessageNotPublished < StandardError; end

    #
    # This exception is being raised in case no targets are
    # specified {Hubbub::Configuration}.
    #
    class NoTargetsSpecified < StandardError; end

    #
    # This exception is being raised upon using a context handler which
    # has never been registered in known handlers.
    #
    class UnknownHandler < StandardError; end
  end
end
