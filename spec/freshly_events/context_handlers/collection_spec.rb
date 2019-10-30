# frozen_string_literal: true

require "spec_helper"

RSpec.describe FreshlyEvents::ContextHandlers::Collection do
  subject(:collection) { described_class.new }

  let(:dummy_handler) do
    class DummyHandler < FreshlyEvents::ContextHandlers::Base
      self.handler_name = :dummy_handler
    end

    DummyHandler
  end

  describe "#choose" do
    context "when a handler is registered" do
      before { collection.register(dummy_handler) }

      it "returns it" do
        expect(collection.choose(handler_name: :dummy_handler)).to eq(DummyHandler)
      end
    end

    context "when a handler is not registered" do
      it "raises" do
        expect {
          collection.choose(handler_name: :unknown)
        }.to raise_error(FreshlyEvents::Exceptions::UnkownHandler)
      end
    end
  end

  describe "#register" do
    context "when handler inherits from correct base class" do
      it "adds it to collection" do
        expect {
          collection.register(dummy_handler)
        }.to change {
          collection
        }.from([]).to([dummy_handler])
      end
    end

    context "when handler inherits from wrong class" do
      let(:dummy_handler) { Class.new }

      it "raises" do
        expect {
          collection.register(dummy_handler)
        }.to raise_error(NotImplementedError, /Hander must inherit from/)
      end
    end
  end

  describe "#unregister" do
    context "when handler inherits from correct class" do
      before { collection.register(dummy_handler) }

      it "removes a handler from collection" do
        expect {
          collection.unregister(dummy_handler)
        }.to change {
          collection
        }.from([dummy_handler]).to([])
      end
    end

    context "when handler inherits from wrong class" do
      let(:dummy_handler) { Class.new }

      it "raises" do
        expect {
          collection.unregister(dummy_handler)
        }.to raise_error(NotImplementedError, /Hander must inherit from/)
      end
    end
  end

  describe "registered?" do
    context "when a handler is present in the collection" do
      before { collection.register(dummy_handler) }

      it "returns true" do
        expect(collection.registered?(dummy_handler)).to eq(true)
      end
    end

    context "when a handler is not present in the collection" do
      it "returns false" do
        expect(collection.registered?(dummy_handler)).to eq(false)
      end
    end
  end
end
