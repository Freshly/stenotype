# frozen_string_literal: true

def init
  sections :header, :summary, [:item_summary], :registry, [T('emission_details')]
end

def stenotype_method_invocations
  object.children
end

def summary_list(method_list_container, &block)
  yield method_list_container.children, method_list_container.name
end
