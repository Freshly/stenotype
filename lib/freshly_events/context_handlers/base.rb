module FreshlyEvents
  module ContextHandlers
    class Base
      attr_reader :context, :options

      def initialize(context, options = {})
        @context = context
        @options = options
      end

      def as_json(*args)
        raise NotImplementedError
      end

      class << self
        attr_writer :handler_name
        def handler_name
          @handler_name or raise NotImplementedError,
            "Please, specify the handler_name of #{self}"
        end
      end
    end
  end
end
