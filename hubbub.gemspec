# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hubbub/version"

Gem::Specification.new do |spec|
  spec.name          = 'hubbub'
  spec.version       = Hubbub::VERSION
  spec.authors       = ["Roman Kapitonov"]
  spec.email         = ["RomanKapitonov@coherentsolutions.com"]

  spec.summary       = 'Fresh pub sub experiment'
  spec.description   = 'Pretty much it'
  spec.homepage      = 'https://www.freshly.com'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'TODO:'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Freshly/freshly-pub-sub-subscriber'
  spec.metadata['changelog_uri'] = 'https://github.com/Freshly/freshly-pub-sub-subscriber/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.0.0'
  spec.add_dependency 'google-cloud-pubsub', '~> 1.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'github-markup', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.5'
  spec.add_development_dependency 'yard', '~> 0.9'

  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rails', '~> 6.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.76'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'timecop', '~> 0.9'
end
