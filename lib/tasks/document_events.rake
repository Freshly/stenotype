# frozen_string_literal: true

namespace :stenotype do
  desc "Documents stenotype usage withing the target application using YARD."

  task document_events: :environment do
    require 'yard'

    # Patch the class from YARD only in rake task
    module YARD
      module CLI
        class Yardoc
          # Track only custom code objects
          def all_objects
            Registry.all(:root, :module, :class, :stenotype_registry, :method_registry)
          end
        end
      end
    end

    # `rm -rf doc/stenotype_events`

    args = [
      "--format", "html",
      "--exclude", "spec/",
      # Output doc to custom directory
      "-o", "./doc/stenotype_events",
      # Use custom extension
      "-e", "stenotype/yard_ext/yard_extension.rb",
      # Silence the output
      "--no-stats",
      "--no-progress",
      # Query only root and two underlying code objects we are particularly interested in
      "--query", "type == :root or type == :stenotype_registry or type == :method_registry",
      # Source code directory
      # "."
      "./yard_test.rb"
      # "./app/services/weekly_order_service.rb"
    ]

    YARD::CLI::Yardoc.run(*args)
  end
end
