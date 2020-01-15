require "stenotype/test/matchers"
require "spec_helper"

RSpec.describe "Stenotype test matcher" do
  let(:emitting_klass) do
    Class.new do
      attr_reader :event_name, :attributes, :eval_context

      def initialize(event_name, attributes, eval_context)
        @event_name = event_name
        @attributes = attributes
        @eval_context = eval_context
      end

      def emitting
        emit_event(event_name, attributes, eval_context: eval_context)
      end

      def emit_event(name, attributes = {}, eval_context: {})
        # noop
      end
    end
  end

  let(:event_name) { "event_name" }
  let(:attributes) { { type: :custom } }
  let(:handler_name) { :klass }
  let(:context) { "context object" }

  subject(:receiver) { emitting_klass.new(event_name, attributes, { handler_name => context }) }

  it "checks event emission parameters" do
    expect(receiver).to emit_event.
      with_name(event_name).
      with_attrs(attributes).
      with_eval_context(handler_name, context)

    receiver.emitting
  end
end
