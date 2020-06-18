# frozen_string_literal: true

require 'yard/handlers/ruby/base'

module Stenotype
  module YardExt
    module Handlers
      class StenotypeContextHandlerWrapper < YARD::Handlers::Ruby::HandlesExtension
        STENOTYPE_CONTEXT_HANDLER_BASE_NAME = "Stenotype::ContextHandlers::Base"

        # We are looking for classes but only specific ones, namely inherited from
        # Stenotype::ContextHandlers::Base. Because this is how you gonna define
        # custom context handlers in the application which uses Stenotype.
        def matches?(node)
          if [:class, :sclass].include?(node.type)
            superclass = parse_superclass(node[1])

            return superclass == STENOTYPE_CONTEXT_HANDLER_BASE_NAME
          end

          false
        end

        def parse_superclass(statement)
          return unless statement

          statement.source
        end
      end
    end
  end
end
