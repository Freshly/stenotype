module FreshlyEvents
  module ContextHandlers
    class Collection < Array
      def choose(handler_name:)
        handler = detect { |p| p.handler_name == handler_name }
        handler or raise FreshlyEvents::Exceptions::UnkownHandler
      end

      def register(handler)
        unless handler < FreshlyEvents::ContextHandlers::Base
          raise NotImplementedError, "Hander must inherit from #{FreshlyEvents::ContextHandlers::Base}"
        end

        push(handler) unless registered?(handler)
      end

      def unregister(handler)
        unless handler < FreshlyEvents::ContextHandlers::Base
          raise NotImplementedError, "Hander must inherit from #{FreshlyEvents::ContextHandlers::Base}"
        end

        push(handler) unless registered?(handler)
      end

      def registered?(handler)
        include?(handler)
      end
    end
  end
end
