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
    allow(Stenotype.config).to receive(:dispatcher).and_return(test_dispatcher_klass)
    allow(test_dispatcher_klass).to receive(:new).and_return(test_dispatcher)
    allow(test_dispatcher).to receive(:publish)
  end

  describe ".emit!" do
    it "delegates emit! to instance of #{described_class}" do
      described_class.emit!({ event: :data })

      expect(test_dispatcher).to have_received(:publish)
    end

    it "returns event" do
      result = described_class.emit!({ event: :data })

      expect(result).to be_a(described_class)
      expect(test_dispatcher).to have_received(:publish)
    end

    context "when the library is disabled" do
      before do
        allow(Stenotype.config).to receive(:targets).and_return([ test_target ])
        allow(Stenotype.config).to receive(:enabled).and_return(false)
      end

      let(:test_buffer) { [] }
      let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

      subject(:emit_event) { described_class.emit!("some_event", *{ key: :value }) }

      it "does not emit any events" do
        expect(test_buffer).to eq([])
        expect(emit_event).to eq(nil)
        expect(test_buffer).to eq([])
      end
    end

    context "when exception is raised" do
      subject(:emit_event) { described_class.emit!("some_event", *{ key: :value }) }

      let(:logger_double) { instance_double(Logger, error: true) }

      before { allow(described_class).to receive(:new).and_raise(StandardError.new("boom")) }

      context "when graceful exception handling is enabled" do
        before { allow(Stenotype.config).to receive(:logger).and_return(logger_double) }

        it "handles error" do
          expect { emit_event }.not_to raise_error
        end
      end

      context "when graceful exception handling is disabled" do
        before do
          allow(Stenotype.config).to receive(:logger).and_return(logger_double)
          allow(Stenotype.config).to receive(:graceful_error_handling).and_return(false)
        end

        it "raises error" do
          expect { emit_event }.to raise_error(Stenotype::Error)
        end
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
        allow(Stenotype.config).to receive(:targets).and_return([ test_target ])
        allow(Stenotype.config).to receive(:enabled).and_return(false)
      end

      subject(:emit_event) { event.emit! }

      let(:test_buffer) { [] }
      let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

      it "does not emit any events" do
        expect(test_buffer).to eq([])
        expect(emit_event).to eq(nil)
        expect(test_buffer).to eq([])
      end
    end

    context "when exception is raised" do
      let(:logger_double) { instance_double(Logger, error: true) }

      before { allow(test_dispatcher).to receive(:publish).and_raise(StandardError.new("boom")) }

      context "when graceful exception handling is enabled" do
        before { allow(Stenotype.config).to receive(:logger).and_return(logger_double) }

        it "handles error" do
          expect { event.emit! }.not_to raise_error
        end
      end

      context "when graceful exception handling is disabled" do
        before do
          allow(Stenotype.config).to receive(:logger).and_return(logger_double)
          allow(Stenotype.config).to receive(:graceful_error_handling).and_return(false)
        end

        it "raises error" do
          expect { event.emit! }.to raise_error(Stenotype::Error)
        end
      end
    end
  end
end
