# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hubbub::Frameworks::ObjectExt do
  subject(:dummy_klass) do
    Class.new do
      emit_event_before :some_method
      emit_klass_event_before :some_class_method

      def some_method
        :result_of_some_method
      end

      class << self
        def name
          'DummyKlass'
        end

        def some_class_method
          :result_of_class_method
        end
      end
    end
  end

  context 'class methods' do
    it 'include emit_event_before' do
      expect(dummy_klass).to respond_to(:emit_event_before)
    end
  end

  context 'instance methods' do
    it 'include emit_event_before' do
      expect(dummy_klass.new).to respond_to(:emit_event_before)
    end
  end

  context 'method' do
    let(:test_buffer) { [] }
    let(:test_target) { Hubbub::TestAdapter.new(test_buffer) }

    before do
      Hubbub.config.targets = [test_target]
    end

    context 'of instance' do
      let(:expected_event_data) do
        {
          type: 'class_instance',
          class: 'DummyKlass',
          method: :some_method,
          timestamp: Time.now.utc,
          uuid: 'abcd'
        }
      end

      it 'is wrapped with an event trigger' do
        expect do
          dummy_klass.new.some_method
        end.to change {
          test_buffer
        }.from([]).to([expected_event_data])
      end
    end

    context 'of class' do
      let(:expected_event_data) do
        {
          type: 'class',
          class: 'DummyKlass',
          method: :some_class_method,
          timestamp: Time.now.utc,
          uuid: 'abcd'
        }
      end

      it 'is wrapped with an event trigger' do
        expect do
          dummy_klass.some_class_method
        end.to change {
          test_buffer
        }.from([]).to([expected_event_data])
      end
    end
  end
end
