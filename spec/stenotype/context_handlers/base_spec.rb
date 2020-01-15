# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers::Base do
  let(:dummy_handler_class) { Class.new(described_class) }

  describe "#as_json" do
    let(:context) { object_double(:context) }
    let(:dummy_handler_instance) { dummy_handler_class.new(context) }

    subject(:as_json) { dummy_handler_instance.as_json }

    context "when it is not implemented" do
      it "raises" do
        expect { as_json }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".handler_name=" do
    subject(:dummy_handler) { dummy_handler_class }

    it { is_expected.to have_attr_accessor(:handler_name) }
  end

  describe ".handler_name" do
    context "when not set" do
      subject(:handler_name) { dummy_handler_class.handler_name }

      it "raises" do
        expect { handler_name }.to raise_error(NotImplementedError)
      end
    end
  end

  describe "#method_missing" do
    let(:context) { object_double(:context) }
    let(:options) { { symbol_key: :value, "string_key" => "value" } }
    subject(:dummy_handler_instance) { dummy_handler_class.new(context, options: options) }

    context "when a key is present in options" do
      it "fetches the value from options" do
        expect(dummy_handler_instance.symbol_key).to eq(:value)
      end

      it "does not depend on whether key is string or symbol" do
        expect(dummy_handler_instance.string_key).to eq("value")
      end
    end

    context "when a key is not present in options" do
      it "raises" do
        expect { dummy_handler_instance.missing_key }.to raise_error(NoMethodError)
      end
    end
  end
end
