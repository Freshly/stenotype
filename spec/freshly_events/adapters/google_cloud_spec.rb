# frozen_string_literal: true

require "spec_helper"

RSpec.describe FreshlyEvents::Adapters::GoogleCloud do
  xdescribe "#publish" do
    context "for async mode" do
      it "publishes the message asynchronously" do
      end
    end

    context "for sync mode" do
      it "publishes the message synchronously" do
      end
    end

    context "for unsupported mode" do
      it "raises" do
      end
    end
  end

  describe "flush_async_queue!" do
    it "flushes the queue" do
    end
  end
end
