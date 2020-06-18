# frozen_string_literal: true

namespace :stenotype do
  desc "Documents stenotype usage withing the target application using YARD."
  require 'stenotype/yard_ext/generator'

  task document_events: :environment do
    # "./**/*.rb"
    # "./yard_test.rb"
    # "./app/services/weekly_order_service.rb"

    Stenotype::YardExt::Generator.new(
      sources: "./yard_test.rb",
      output_dir: "./doc/stenotype_events",
      exclude: "spec/",
      format: "html"
    ).run
  end
end
