# frozen_string_literal: true

namespace :stenotype do
  desc "Documents stenotype usage withing the target application using YARD."
  require 'stenotype/yard_ext/generator'

  task document_events: :environment do
    Stenotype::YardExt::Generator.new(
      sources: "./yard_test.rb",
      output_dir: "./doc/stenotype_events",
      exclude: "spec/",
      format: "html"
    ).run
  end
end
