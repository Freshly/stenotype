# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'timecop'
require 'pry'

require 'rails'
require 'action_controller'
require 'active_job'

# SimpleCov.profiles.define 'gem' do
#   track_files '{lib}/**/*.rb'

#   add_filter '/spec'
#   add_filter 'lib/stenotype/version.rb'
# end

# SimpleCov.start 'gem'

require 'stenotype'
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

  config.before(:suite) do |_example|
    # Configure a dummy target
    Stenotype.configure do |c|
      c.targets = [Stenotype::TestAdapter.new([])]
      c.uuid_generator = Stenotype::TestUuidGen
    end
  end

  module Stenotype
    module ContextHandlers
      def self.reset_defaults!
        self.known = Stenotype::ContextHandlers::Collection.new
        register Stenotype::ContextHandlers::Klass
        register Stenotype::ContextHandlers::Rails::ActiveJob
        register Stenotype::ContextHandlers::Rails::Controller
      end
    end
  end
end
