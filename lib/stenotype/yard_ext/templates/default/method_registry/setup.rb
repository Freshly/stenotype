# frozen_string_literal: true

def init
  sections :header, :summary, [:item_summary], :registry, [T('emission_details')]
end

def group_by_event_name_type
  object.children.partition do |mo|
    mo[:dynamic_event_name]
  end.map do |list|
    list.sort_by!(&:event_name)
  end
end

def static_events_method_invocations
  _, static = group_by_event_name_type
  static
end

def dynamic_events_method_invocations
  dynamic, _ = group_by_event_name_type
  dynamic
end
