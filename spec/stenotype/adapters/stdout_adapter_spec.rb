# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::StdoutAdapter do
  describe "#publish" do
    let(:client_double) { instance_double(Logger) }
    let(:event_data) { { event: :data } }
    let(:additional_arguments) { { additional: :arguments } }

    subject(:adapter) { described_class.new(client: client_double) }

    before { allow(client_double).to receive(:info) { |&block| block.call } }

    it "publishes the message to STDOUT" do
      adapter.publish(event_data, additional_arguments)

      expect(client_double).to have_received(:info).with("[Stenotype::Event] emitted with the following attributes")
    end
  end
end
