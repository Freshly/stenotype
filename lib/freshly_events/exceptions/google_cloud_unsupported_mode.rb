module FreshlyEvents
  module Exceptions
    #
    # This exception is being raised in case an unsupported mode
    # for Google Cloud is specified.
    #
    class GoogleCloudUnsupportedMode < StandardError
    end
  end
end
