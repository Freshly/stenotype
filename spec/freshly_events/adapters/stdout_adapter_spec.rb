# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FreshlyEvents::Adapters::StdoutAdapter do
  describe '#publish' do
    let(:client_double) { double(:client) }

    subject(:adapter) { described_class.new(client: client_double) }

    before { allow(client_double).to receive(:info).and_return(client_double) }

    let(:event_data) { { event: :data } }
    let(:additional_arguments) { { additional: :arguments } }

    it 'publishes the message to STDOUT' do
      expect(client_double).to receive(:info).with(event_data, additional_arguments)

      adapter.publish(event_data, additional_arguments)
    end
  end
end
