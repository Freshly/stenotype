# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hubbub::Dispatcher do
  describe '#publish' do
    let(:dummy_serializer) do
      Class.new do
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def serialize
          { dummy_key: 'dummy value' }
        end
      end
    end

    let(:test_target) { Hubbub::TestAdapter.new }
    let(:event) { Hubbub::Event.new('dummy data') }

    subject(:dispatcher) { described_class.new }

    before do
      config = Hubbub.config
      config.targets = [test_target]
    end

    it 'dispatches the event to configured targets' do
      expect(test_target).to receive(:publish).with(dummy_key: 'dummy value')

      dispatcher.publish(event, serializer: dummy_serializer)
    end
  end
end
