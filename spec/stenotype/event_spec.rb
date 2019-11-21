# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::Event do
  let(:dummy_dispatcher) { Stenotype::TestDispatcher.new }

  describe '.emit!' do
    it "delegates emit! to instance of #{described_class}" do
      expect {
        described_class.emit!({ event: :data }, dispatcher: dummy_dispatcher)
      }.to change {
        dummy_dispatcher.dispatched_events.count
      }.from(0).to(1)
    end

    it 'returns event' do
      result = described_class.emit!({ event: :data }, dispatcher: dummy_dispatcher)

      expect(result).to be_a(described_class)
    end
  end

  describe '#emit!' do
    subject(:event) { described_class.new({ event: :data }, dispatcher: dummy_dispatcher) }

    it 'delegates the event to a dispatcher' do
      expect {
        event.emit!
      }.to change {
        dummy_dispatcher.dispatched_events
      }.from([]).to([event])
    end
  end
end
