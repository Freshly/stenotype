# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hubbub::ContextHandlers do
  subject(:context_handlers) { described_class }

  describe '.known' do
    context 'when no handler(s) specified' do
      before { context_handlers.known = nil }

      it 'returns an empty handlers collection' do
        expect(context_handlers.known).to be_empty
        expect(context_handlers.known).to be_a(Array)
      end

      after { Hubbub::ContextHandlers.reset_defaults! }
    end

    context 'when there are registered handlers' do
      let(:test_handler) { Hubbub::TestHandler }

      before do
        context_handlers.known = nil
        context_handlers.register test_handler
      end

      it 'returns the collection of handlers' do
        expect(context_handlers.known).to match_array([test_handler])
      end

      after { Hubbub::ContextHandlers.reset_defaults! }
    end
  end

  describe '.register' do
    let(:test_handler) { Hubbub::TestHandler }

    before { context_handlers.known = nil }

    it 'registers a handler in the list of known handlers' do
      expect(context_handlers.known).to be_empty
      context_handlers.register test_handler
      expect(context_handlers.known).to match_array([test_handler])
    end

    after { Hubbub::ContextHandlers.reset_defaults! }
  end
end
