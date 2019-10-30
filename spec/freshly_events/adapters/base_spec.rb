# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FreshlyEvents::Adapters::Base do
  describe '#publish' do
    let(:dummy_klass) { Class.new(described_class) }
    subject(:dummy_klass_instance) { dummy_klass.new }

    context 'when not implemented' do
      let(:event_data) { double(:event_data) }

      it 'raises NotImplementedError' do
        expect do
          dummy_klass_instance.publish(event_data)
        end.to raise_error(NotImplementedError, /must implement method #publish/)
      end
    end

    context 'when a subclass implements method #publish' do
      before do
        dummy_klass.class_eval do
          def publish(*_args)
            true # do nothing
          end
        end
      end

      it 'does not raise' do
        expect(dummy_klass_instance.publish).to be_truthy
      end
    end
  end
end
