# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Event do
  let(:test_dispatcher_klass) do
    Class.new do
      def publish(event)
        event
      end
    end
  end

  let!(:test_dispatcher) { test_dispatcher_klass.new }

  before do
    allow(test_dispatcher_klass).to receive(:new).and_return(test_dispatcher)
    allow(test_dispatcher).to receive(:publish)

    Stenotype.configure { |config| config.dispatcher = test_dispatcher_klass }
  end

  after do
    Stenotype.configure { |config| config.dispatcher = Stenotype::Dispatcher }
  end

  describe ".emit!" do
    it "delegates emit! to instance of #{described_class}" do
      described_class.emit!(event: :data)

      expect(test_dispatcher).to have_received(:publish)
    end

    it "returns event" do
      result = described_class.emit!(event: :data)

      expect(result).to be_a(described_class)
      expect(test_dispatcher).to have_received(:publish)
    end

    context "when the library is disabled" do
      before do
        Stenotype.configure do |config|
          config.targets = [ test_target ]
          config.enabled = false
        end
      end

      after { Stenotype.configure { |config| config.enabled = true } }

      let(:test_buffer) { [] }
      let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

      subject(:emit_event) { described_class.emit!("some_event", *{ key: :value }) }

      it "does not emit any events" do
        expect(test_buffer).to eq([])
        expect(emit_event).to eq(nil)
        expect(test_buffer).to eq([])
      end
    end
  end

  describe "#emit!" do
    subject(:event) { described_class.new("some_event", *{ event: :data }) }

    it "delegates the event to a dispatcher" do
      event.emit!
      expect(test_dispatcher).to have_received(:publish)
    end

    context "when the library is disabled" do
      before do
        Stenotype.configure do |config|
          config.targets = [ test_target ]
          config.enabled = false
        end
      end

      after { Stenotype.configure { |config| config.enabled = true } }

      subject(:emit_event) { event.emit! }

      let(:test_buffer) { [] }
      let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

      it "does not emit any events" do
        expect(test_buffer).to eq([])
        expect(emit_event).to eq(nil)
        expect(test_buffer).to eq([])
      end
    end
  end
end
