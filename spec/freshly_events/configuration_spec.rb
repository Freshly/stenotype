# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hubbub::Configuration do
  subject(:configuration) { described_class }

  describe '.targets' do
    context 'when a target(s) have been specified' do
      let(:test_target) { Hubbub::TestAdapter.new }
      before { Hubbub.config.targets = [test_target] }

      it 'returns it' do
        expect(configuration.targets).to match_array([test_target])
      end
    end

    context 'when no targets have been specified' do
      before { Hubbub.config.targets = [] }

      it 'raises' do
        expect do
          configuration.targets
        end.to raise_error(
          Hubbub::Exceptions::NoTargetsSpecified,
          /Please configure a target\(s\)/
        )
      end
    end
  end

  it { should have_attr_accessor(:gc_credentials) }
  it { should have_attr_accessor(:gc_project_id) }
  it { should have_attr_accessor(:gc_topic) }
  it { should have_attr_accessor(:gc_mode) }
  it { should have_attr_accessor(:dispatcher) }

  describe '.configure' do
    it 'yields self' do
      expect { |b| configuration.configure(&b) }.to yield_control
    end
  end
end
