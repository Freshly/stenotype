RSpec::Matchers.define :emit_event do |reciever|
  match do |reciever|
    expectation = expect(receiver).to receive(:emit_event)

    with = []
    with << @event_name
    with << (@additional_attrs.present? ? @additional_attrs : anything)
    with << (@eval_context_passed ? { eval_context: { @handler_name => @context } } : anything)

    expectation = expectation.with(*with) if with.any?
    expectation.and_call_original
    expectation
  end

  chain :with_name do |event_name|
    @event_name = event_name
  end

  chain :with_attrs do |additional_attrs|
    @additional_attrs = additional_attrs
  end

  chain :with_eval_context do |handler_name, context|
    @eval_context_passed = true
    @handler_name = handler_name
    @context = context
  end
end
