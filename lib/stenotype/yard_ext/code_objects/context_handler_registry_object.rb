# frozen_string_literal: true

class ContextHandlerRegistryObject < YARD::CodeObjects::ClassObject
  # This is a simple registry! Note that this code object is not
  # going to be rendered explicitly. The contents of the registry
  # are used to find docstrings with context handler description
  # which is placed in a @tag.
  def type
    :context_handler_doc
  end
end
