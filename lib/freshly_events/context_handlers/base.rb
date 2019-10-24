module FreshlyEvents
  module ContextHandlers
    class Base
      def intitialize(context, options = {})
        @context = context
        @options = options
      end

      def as_json(*args)
        raise NotImplementedError
      end

      # TODO: r.kapitonov do we need this to dynamically collect available handlers?
      # or should we consider explicit specification of the handlers?
      #
      class << self
        attr_accessor :handler_name
      end
    end
  end
end
