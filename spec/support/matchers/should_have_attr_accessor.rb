# frozen_string_literal: true

RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object_instance|
    #
    # @todo r.kapitonov How to reuse have_attr_reader/have_attr_writer?
    #
    object_instance.respond_to?(field) &&
      object_instance.respond_to?("#{field}=")
  end

  failure_message do |object_instance|
    "expected attr_accessor for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_accessor for #{field} not " \
      "to be defined on #{object_instance}"
  end

  description do |_object_instance|
    "have attr_accessor for #{field}"
  end
end
