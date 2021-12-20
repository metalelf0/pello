require_relative 'lib/pello/version'

Gem::Specification.new do |spec|
  spec.name          = 'pello'
  spec.version       = Pello::VERSION
  spec.authors       = ['Andrea Schiavini']
  spec.email         = ['metalelf0@gmail.com']

  spec.summary       = 'A console tool to do Trello operations'
  spec.description   = 'Perform Trello operations like adding pomodori to a card title'
  spec.homepage      = 'https://github.com/metalelf0/pello'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = "https://rubygems.org"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/metalelf0/pello'
  spec.metadata['changelog_uri'] = 'https://github.com/metalelf0/pello'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.glob('{bin,lib}/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'ruby-trello', '~> 3.0'
  spec.add_runtime_dependency 'tty-prompt', '~> 0'
  spec.add_runtime_dependency 'tty-table', '~> 0'
end
