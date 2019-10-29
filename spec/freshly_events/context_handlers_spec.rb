require 'spec_helper'

RSpec.describe FreshlyEvents::ContextHandlers do
  subject(:context_handlers) { described_class }

  describe ".known" do
    context 'when no handler(s) specified' do
      before { context_handlers.known = nil }

      it "returns an empty handlers collection" do
        expect(context_handlers.known).to be_empty
        expect(context_handlers.known).to be_a(Array)
      end
    end

    context "when there are registered handlers" do
      let(:test_handler) { FreshlyEvents::TestHandler }

      before { context_handlers.register test_handler }

      it "returns the collection of handlers" do
        expect(context_handlers.known).to match_array([test_handler])
      end
    end
  end

  describe ".register" do
    let(:test_handler) { FreshlyEvents::TestHandler }

    before { context_handlers.known = nil }

    it "registers a handler in the list of known handlers" do
      expect(context_handlers.known).to be_empty
      context_handlers.register test_handler
      expect(context_handlers.known).to match_array([test_handler])
    end
  end
end
