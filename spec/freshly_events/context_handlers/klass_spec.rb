# frozen_string_literal: true

require "spec_helper"

RSpec.describe FreshlyEvents::ContextHandlers::Klass do
  describe ".handler_name" do
    subject(:handler_klass) { described_class }

    it "should equal to :klass" do
      expect(handler_klass.handler_name).to eq(:klass)
    end
  end

  describe "#as_json" do
    let(:context) { double(:context) }
    subject(:handler) { described_class.new(context) }

    it "returns json representation of context" do
      expect(handler.as_json).to eq({})
    end
  end
end
