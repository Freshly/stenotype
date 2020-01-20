# frozen_string_literal: true

# :nocov:
require "stenotype"

at_exit do
  targets = Stenotype.config.targets
  targets.each(&:flush!)
end
# :nocov:
