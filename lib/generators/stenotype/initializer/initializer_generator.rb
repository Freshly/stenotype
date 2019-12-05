# frozen_string_literal: true

module Stenotype
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template "initializer.rb.erb", File.join("config/initializers/stenotype.rb")
      end
    end
  end
end
