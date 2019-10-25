require 'spec_helper'

RSpec.describe FreshlyEvents::Adapters::GoogleCloud do
  describe "#publish" do
    context "for async mode" do
      it "publishes the message asynchronously" do
        pending 'TODO'
      end
    end

    context "for sync mode" do
      it "publishes the message synchronously" do
        pending 'TODO'
      end
    end

    context "for unsupported mode" do
      it "raises" do
        pending 'TODO'
      end
    end
  end

  describe "flush_async_queue!" do
    it "flushes the queue" do
      pending 'TODO'
    end
  end
end
