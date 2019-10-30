# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'timecop'

SimpleCov.profiles.define 'gem' do
  track_files '{lib}/**/*.rb'

  add_filter '/spec'
  add_filter 'lib/freshly_events/version.rb'
end

SimpleCov.start 'gem'

require 'freshly_events'
Dir[File.join(File.expand_path(__dir__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around(:each) do |example|
    Timecop.freeze(Time.local(2019))
    example.run
    Timecop.return
  end
end

# Configure a dummy target
#
FreshlyEvents.configure do |config|
  config.targets = [
    FreshlyEvents::TestAdapter.new
  ]
end
