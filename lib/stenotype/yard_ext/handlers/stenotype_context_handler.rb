# frozen_string_literal: true

#
# A class for handing subclasses of Stenotype::ContextHandlers::Base
# It allows to fetch the result context hash in case #as_json is defined
# explicitly
#
module Stenotype
  module YardExt
    module Handlers
      class StenotypeContextHandler < YARD::Handlers::Ruby::Base
        handles StenotypeContextHandlerWrapper.new(:context_handler)

        process do
          # Define a var to store the handler name while traversing AST nodes
          handler_name = nil
          # @todo Handle custom tags!
          statement.traverse do |node|
            # We are looking for assigns
            next unless node.type == :assign
            # The name of the field is "handler_name"
            next unless node.jump(:ident).source == "handler_name"
            # The second part of the assignment is the context handler name, which we are looking for
            handler_name = node[1].jump(:ident).source
          end

          # We are registering a code object under root, with a handler name as identifier
          register ContextHandlerRegistryObject.new(:root, handler_name)
        end
      end
    end
  end
end
