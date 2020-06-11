# frozen_string_literal: true

require 'securerandom'
require 'set'

require_relative 'code_objects/stenotype_registry_object'
require_relative 'code_objects/method_registry_object'
require_relative 'code_objects/context_handler_registry_object'

require_relative 'handlers/methods_enum'
require_relative 'handlers/ast_traverse'
require_relative 'handlers/stenotype_context_handler_wrapper'
require_relative 'handlers/stenotype_context_handler'
require_relative 'handlers/stenotype_methods_handler'

require_relative 'templates/helpers/emit_event_signature_helper'

# Register a new helper to customize emit_event signature
YARD::Templates::Template.extra_includes.push(EmitEventSignatureHelper)
# Register a new tag handler to parse the documentation for a specific context handler in Stenotype world
YARD::Tags::Library.define_tag("Context Hander Doc", :context_handler_doc, :with_title_and_text)
# Register custom templates path for rendering registry object
template_path = File.expand_path(File.join(File.dirname(__FILE__), "templates"))
YARD::Templates::Engine.register_template_path(template_path)
