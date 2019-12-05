require 'spec_helper'
require 'generators/stenotype/initializer/initializer_generator'

RSpec.describe Stenotype::Generators::InitializerGenerator, type: :generator do
  setup_default_destination

  describe "#create_initializer" do
    before { run_generator %w('stenotype:initializer') }

    subject(:config_file_path) { file("config/initializers/stenotype.rb") }

    it 'exists' do
      expect(File.exists?(config_file_path)).to eq(true)
    end

    it 'contains Rails.application.configure' do
      expect(File.read(config_file_path)).to match(/Rails.application.configure/)
    end

    it 'contains # config.stenotype' do
      expect(File.read(config_file_path)).to match(/# config.stenotype/)
    end
  end
end
