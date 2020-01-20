# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::StdoutAdapter do
  let(:client_double) { instance_double(Logger) }
  let(:event_data) { { event: :data } }
  let(:additional_arguments) { { additional: :arguments } }

  let(:adapter) { described_class.new(client: client_double) }

  describe "#publish" do
    subject(:publish) { adapter.publish(event_data, additional_arguments) }

    before { allow(client_double).to receive(:info).and_yield }

    it "publishes the message to STDOUT" do
      publish

      expect(client_double).to have_received(:info).with("[Stenotype::Event] emitted with the following attributes")
    end
  end

  describe "#flush!" do
    subject(:flush!) { adapter.flush! }

    it "does nothing" do
      expect(flush!).to eq(nil)
    end
  end

  describe "#setup!" do
    subject(:setup!) { adapter.setup! }

    it "does nothing" do
      expect(setup!).to eq(nil)
    end
  end
end
