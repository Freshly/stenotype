require 'stenotype'

# :nocov:
at_exit do
  targets = Stenotype.config.targets
  targets.each(&:flush!)
end
# :nocov: