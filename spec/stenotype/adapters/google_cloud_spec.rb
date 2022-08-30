# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::GoogleCloud do
  let(:fake_topic) do
    Class.new do
      def publish(event_data, **opts); end
      def publish_async(event_data, **opts); end
      def async_publisher; end
    end
  end

  let(:fake_client) do
    Class.new do
      def topic(name); end
    end
  end

  let(:fake_result) do
    Class.new do
      def succeeded?; end
    end
  end

  let(:fake_publisher) do
    Class.new do
      def stop; end
      def wait!; end
    end
  end

  let(:fake_publisher_double) { instance_double(fake_publisher, wait!: true) }
  let(:topic_double) { instance_double(fake_topic, publish: true, publish_async: true) }
  let(:fake_client_double) { instance_double(fake_client, topic: topic_double) }
  let(:adapter) { described_class.new(client: fake_client_double) }

  describe "#publish" do
    let(:event_data) { { event: :data } }
    let(:additional_arguments) { { additional: :arguments } }

    subject(:publish) { adapter.publish(event_data, **additional_arguments) }

    before { allow(Stenotype.config).to receive_message_chain(:google_cloud, :topic).and_return("test") }

    context "when in async mode" do
      before { allow(Stenotype.config).to receive_message_chain(:google_cloud, :async).and_return(true) }

      context "when publishing has succeeded" do
        it "publishes the message asynchronously" do
          publish

          expect(topic_double).to have_received(:publish_async).with(event_data, additional_arguments).once
        end
      end

      context "when publish has not succeeded" do
        let(:failed_result) { instance_double(fake_result, succeeded?: false) }

        before { allow(topic_double).to receive(:publish_async).and_yield(failed_result) }

        it "raises" do
          expect { publish }.to raise_error(Stenotype::MessageNotPublishedError)
        end
      end
    end

    context "when in sync mode" do
      before { allow(Stenotype.config).to receive_message_chain(:google_cloud, :async).and_return(false) }

      it "publishes the message synchronously" do
        publish

        expect(topic_double).to have_received(:publish).with(event_data, additional_arguments).once
      end
    end
  end

  describe "#flush!" do
    subject(:flush!) { adapter.flush! }

    context "when async_publisher is not initialized" do
      before { allow(topic_double).to receive(:async_publisher).and_return(nil) }

      it "does nothing" do
        expect(flush!).to eq(nil)
        expect(topic_double).to have_received(:async_publisher).once
      end
    end

    context "when async_publisher is initialized" do
      before do
        allow(fake_publisher_double).to receive(:stop).and_return(fake_publisher_double)
        allow(topic_double).to receive(:async_publisher).and_return(fake_publisher_double)
      end

      it "stops the publisher" do
        flush!

        expect(topic_double).to have_received(:async_publisher).twice
        expect(fake_publisher_double).to have_received(:stop).once
        expect(fake_publisher_double).to have_received(:wait!).once
      end
    end
  end

  describe "#auto_initialize!" do
    let(:auto_initialize!) { adapter.auto_initialize! }

    context "when a client is passed" do
      it "sets up client and topic" do
        expect { auto_initialize! }.not_to change { adapter.instance_variable_get(:@client) }
      end
    end

    context "when a client is not passed" do
      let(:adapter) { described_class.new }

      before { allow(Google::Cloud::PubSub).to receive(:new).and_return(fake_client_double) }

      it "setup client and topic" do
        expect(adapter.instance_variable_get(:@client)).to eq(nil)
        expect(adapter.instance_variable_get(:@topic)).to eq(nil)

        auto_initialize!

        expect(adapter.instance_variable_get(:@client)).to eq(fake_client_double)
        expect(adapter.instance_variable_get(:@topic)).to eq(topic_double)
      end
    end
  end
end
