# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::Configuration, type: :configuration do
  subject(:configuration) { described_class }

  describe '.targets' do
    context 'when a target(s) have been specified' do
      let(:test_target) { Stenotype::TestAdapter.new }
      before do
        Stenotype::Configuration.configure do |c|
          c.targets = [test_target]
        end
      end

      it 'returns it' do
        expect(configuration.targets).to match_array([test_target])
      end
    end

    context 'when no targets have been specified' do
      before do
        Stenotype::Configuration.configure do |c|
          c.targets = []
        end
      end

      it 'raises' do
        expect do
          configuration.targets
        end.to raise_error(
          Stenotype::Errors::NoTargetsSpecified,
          /Please configure a target\(s\)/
        )
      end
    end
  end

  it { is_expected.to define_config_option :targets, default: [] }
  it { is_expected.to define_config_option :dispatcher }
  it { is_expected.to define_config_option :uuid_generator, default: SecureRandom }

  nested_config_option :rails do
    it { is_expected.to define_config_option(:enable_action_controller_ext, default: true) }
    it { is_expected.to define_config_option(:enable_active_job_ext, default: true) }
  end

  nested_config_option :google_cloud do
    it { is_expected.to define_config_option :credentials }
    it { is_expected.to define_config_option :project_id }
    it { is_expected.to define_config_option :topic }
    it { is_expected.to define_config_option :mode }
  end
end
