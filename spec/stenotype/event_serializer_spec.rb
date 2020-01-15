# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::EventSerializer do
  subject(:serializer) { described_class.new(event, uuid_generator: Stenotype::TestUuidGen) }

  let(:event_name) { "event_name" }
  let(:data) do
    {
      data_key: "data value",
      type: :custom,
      triggered_by_class: "SomeClass",
      triggered_by: "something",
      triggered_by_method: "some_method",
      custom_attribute: "custom_attribute",
    }
  end
  let(:eval_context) { { klass: dummy_context.new } }

  let(:event) do
    Stenotype::Event.new(
      event_name,
      data,
      eval_context: eval_context,
    )
  end

  let(:dummy_context) { Class.new }

  describe "#serialize", type: :with_frozen_time do
    it "represents an event as a hash" do
      expect(serializer.serialize).to eq(
        name: event_name,
        type: :custom,
        triggered_by_class: "SomeClass",
        triggered_by: "something",
        triggered_by_method: "some_method",
        timestamp: Time.now.utc,
        uuid: "abcd",
      )
    end

    it "merges only designating attributes from additional attrs" do
      expect(serializer.serialize).to_not have_key(:custom_attribute)
    end
  end
end
