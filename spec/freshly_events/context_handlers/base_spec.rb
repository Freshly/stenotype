# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FreshlyEvents::ContextHandlers::Base do
  let(:dummy_handler_class) { Class.new(described_class) }

  describe '#as_json' do
    let(:context) { double(:context) }

    subject(:dummy_handler_instance) { dummy_handler_class.new(context) }

    context 'when it is not implemented' do
      it 'raises' do
        expect do
          dummy_handler_instance.as_json
        end.to raise_error(NotImplementedError, /must implement method/)
      end
    end
  end

  describe '.handler_name=' do
    subject(:dummy_handler) { dummy_handler_class }

    it { is_expected.to have_attr_accessor(:handler_name) }
  end

  describe '.handler_name' do
    context 'when not set' do
      it 'raises' do
        expect do
          dummy_handler_class.handler_name
        end.to raise_error(NotImplementedError, /Please, specify the handler_name/)
      end
    end
  end
end
