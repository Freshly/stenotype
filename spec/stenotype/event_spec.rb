# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::Event do
  before do
    expect_any_instance_of(Stenotype::Dispatcher).to receive(:publish).and_call_original
  end

  describe '.emit!' do
    it "delegates emit! to instance of #{described_class}" do
      described_class.emit!({ event: :data })
    end

    it 'returns event' do
      result = described_class.emit!({ event: :data })

      expect(result).to be_a(described_class)
    end
  end

  describe '#emit!' do
    subject(:event) { described_class.new({ event: :data }) }

    it 'delegates the event to a dispatcher' do
      event.emit!
    end
  end
end
