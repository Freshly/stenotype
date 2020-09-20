require 'yard'
require 'active_support/core_ext'

module Stenotype
  # Patch the class from YARD to enable custom registries
  module ::YARD
    module CLI
      class Yardoc
        # Track only custom code objects
        def all_objects
          Registry.all(:root, :module, :class, :stenotype_registry, :method_registry)
        end
      end
    end
  end

  module YardExt
    class Generator
      attr_reader :sources, :output_dir, :exclude, :format

      def initialize(sources:, output_dir: "./doc/stenotype_events", exclude: "spec/", format: "html")
        @sources = Array.wrap(sources)
        @output_dir = output_dir
        @exclude = Array.wrap(exclude)
        @format = format
      end

      def run
        args = [
          "--format", format,
          "--exclude", *exclude,
          # Output doc to custom directory
          "-o", output_dir,
          # Use custom extension
          "-e", "stenotype/yard_ext/yard_extension.rb",
          # Silence the output
          "--no-stats",
          "--no-progress",
          # Query only root and two underlying code objects we are particularly interested in
          "--query", "type == :root or type == :stenotype_registry or type == :method_registry",
          # Source code directory
          *sources
        ]

        YARD::CLI::Yardoc.run(*args)
      end
    end
  end
end
