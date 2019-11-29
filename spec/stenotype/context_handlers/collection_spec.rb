# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stenotype::ContextHandlers::Collection do
  subject(:collection) { described_class.new }

  let(:dummy_handler) do
    Class.new(Stenotype::ContextHandlers::Base) do
      self.handler_name = :dummy_handler

      class << self
        def name
          'DummyHandler'
        end
      end
    end
  end

  describe '#choose' do
    context 'when a handler is registered' do
      before { collection.register(dummy_handler) }

      it 'returns it' do
        expect(collection.choose(handler_name: :dummy_handler).name).to eq('DummyHandler')
      end
    end

    context 'when a handler is not registered' do
      it 'raises' do
        expect do
          collection.choose(handler_name: :unknown)
        end.to raise_error(Stenotype::Errors::UnknownHandler)
      end
    end
  end

  describe '#register' do
    it 'adds it to collection' do
      expect do
        collection.register(dummy_handler)
      end.to change {
        collection.items
      }.from([]).to([dummy_handler])
    end
  end

  describe '#unregister' do
    before { collection.register(dummy_handler) }

    it 'removes a handler from collection' do
      expect do
        collection.unregister(dummy_handler)
      end.to change {
        collection.items
      }.from([dummy_handler]).to([])
    end
  end

  describe 'registered?' do
    context 'when a handler is present in the collection' do
      before { collection.register(dummy_handler) }

      it 'returns true' do
        expect(collection.registered?(dummy_handler)).to eq(true)
      end
    end

    context 'when a handler is not present in the collection' do
      it 'returns false' do
        expect(collection.registered?(dummy_handler)).to eq(false)
      end
    end
  end
end
