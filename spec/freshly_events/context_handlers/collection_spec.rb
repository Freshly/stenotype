require 'spec_helper'

RSpec.describe FreshlyEvents::ContextHandlers::Collection do
  subject(:collection) { described_class.new }

  describe "#choose" do
    context "when a handler is registered" do
      it "returns it" do
        pending 'TODO'
      end
    end

    context "when a handler is not registered" do
      it "raises" do
        pending 'TODO'
      end
    end
  end

  describe "#register" do
    context "when handler inherits from correct base class" do
      it "adds it to collection" do
        pending 'TODO'
      end
    end

    context "when handler inherits from wrong class" do
      it "raises" do
        pending 'TODO'
      end
    end
  end

  describe "#unregister" do
    context "when handler inherits from correct class" do
      it "removes a handler from collection" do
        pending 'TODO'
      end
    end

    context "when handler inherits from wrong class" do
      it "raises" do
        pending 'TODO'
      end
    end
  end

  describe "registered?" do
    context "when a handler is present in the collection" do
      it "returns true" do
        pending 'TODO'
      end
    end

    context "when a handler is not present in the collection" do
      it "returns false" do
        pending 'TODO'
      end
    end
  end
end
