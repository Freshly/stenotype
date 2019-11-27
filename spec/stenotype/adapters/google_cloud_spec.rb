# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::Adapters::GoogleCloud do
  describe '#publish' do
    let(:topic_double) do
      double(:topic,
             publish: 'sync publish',
             publish_async: 'async publish')
    end

    let(:fake_client) { double(:client, topic: topic_double) }

    let(:event_data) { { event: :data } }
    let(:additional_arguments) { { additional: :arguments } }

    subject(:adapter) { described_class.new(client: fake_client) }

    context 'for async mode' do
      before do
        Stenotype::Configuration.configure do |c|
          c.google_cloud.mode = :async
        end
      end

      context 'when publishing has succeeded' do
        it 'publishes the message asynchronously' do
          expect(topic_double).to receive(:publish_async).with(event_data, additional_arguments).once

          adapter.publish(event_data, additional_arguments)
        end
      end

      context 'when publish has not succeeded' do
        let(:failed_result) { double(:result, succeeded?: false) }

        before { allow(topic_double).to receive(:publish_async).and_yield(failed_result) }

        it 'raises' do
          expect do
            adapter.publish(event_data, additional_arguments)
          end.to raise_error(Stenotype::Errors::MessageNotPublished)
        end
      end
    end

    context 'for sync mode' do
      before do
        Stenotype::Configuration.configure do |c|
          c.google_cloud.mode = :sync
        end
      end

      it 'publishes the message synchronously' do
        expect(topic_double).to receive(:publish).with(event_data, additional_arguments).once

        adapter.publish(event_data, additional_arguments)
      end
    end

    context 'for unsupported mode' do
      before do
        Stenotype::Configuration.configure do |c|
          c.google_cloud.mode = :unsupported
        end
      end

      it 'raises' do
        expect do
          described_class.new.publish(event_data, additional_arguments)
        end.to raise_error(Stenotype::Errors::GoogleCloudUnsupportedMode,
                           /Please use either :sync/)
      end
    end
  end
end
