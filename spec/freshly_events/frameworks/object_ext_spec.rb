# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FreshlyEvents::Frameworks::ObjectExt do
  subject(:dummy_klass) do
    Class.new do
      extend FreshlyEvents::Frameworks::ObjectExt

      emit_event_before :some_method

      def some_method
        :result_of_some_method
      end

      class << self
        def name
          'DummyKlass'
        end
      end
    end
  end

  let(:expected_event_data) do
    {
      type: 'class',
      class: 'DummyKlass',
      method: :some_method,
      timestamp: Time.now.utc
    }
  end

  describe '.emit_event_before' do
    let(:test_buffer) { [] }
    let(:test_target) { FreshlyEvents::TestAdapter.new(test_buffer) }

    before { FreshlyEvents.config.targets = [test_target] }

    it 'wrap a method call with event trigger' do
      expect do
        dummy_klass.new.some_method
      end.to change {
        test_buffer
      }.from([]).to([expected_event_data])
    end
  end
end
