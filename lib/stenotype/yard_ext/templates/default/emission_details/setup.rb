# frozen_string_literal: true

class NullHandler
  def tags
    [YARD::Tags::Tag.new("context_handler_doc", text, [], name)]
  end

  private

  def name
    "No context inferable attributes"
  end

  def text
    ""
  end
end

def init
  sections :details, :source
end

def map_callee_to_context_handler(callee)
  # Fetch all documented context handlers
  context_handlers_registry = Registry.all(:context_handler_doc)
  # Fetch handler name for the emitted event
  callee_handler_name = callee["handler_name"]
  # Try to find a matching context handler to fetch the list of attributes from it
  matching_handler = context_handlers_registry.detect do |handler|
    handler.name.to_s == callee_handler_name
  end

  # If not found fallback to a NullHandler to indicate missing documentation
  matching_handler || NullHandler.new
end

# Select a list of custom tags
def stenotype_tags_for_handler(handler)
  handler.tags.select { |h| h.tag_name.to_s == "context_handler_doc" }
end

def render_html_doc_for(callee)
  matching_handler = map_callee_to_context_handler(callee)
  documentation_tags = stenotype_tags_for_handler(matching_handler)

  context = [
    *documentation_tags,
    *callee["default_attributes_tag"],
    *callee["additional_attributes_tag"]
  ].map do |tag|
    [
      "<h3>#{tag.name}</h3>",
      tag.text.split("\n").map { |event_attribute| "<code>#{event_attribute}</code>" }.join(", ")
    ]
  end.join("\n")

  context || ""
end

