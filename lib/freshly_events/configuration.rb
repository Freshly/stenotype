module FreshlyEvents
  module Configuration
    class << self
      attr_accessor :targets
      attr_accessor :gc_credentials
      attr_accessor :gc_project_id
      attr_accessor :gc_topic
      attr_accessor :gc_mode

      attr_accessor :dispatcher

      def configure
        yield self
      end
    end
  end
end
