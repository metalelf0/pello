require_relative 'lib/pello/version'

Gem::Specification.new do |spec|
  spec.name          = 'pello'
  spec.version       = Pello::VERSION
  spec.authors       = ['Andrea Schiavini']
  spec.email         = ['metalelf0@gmail.com']

  spec.summary       = 'A console tool to do Trello operations'
  spec.description   = 'Perform Trello operations like adding pomodori to a card title'
  spec.homepage      = "http://somewhere.com/pello"
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "http://somewhere.com/pello"
  spec.metadata['changelog_uri'] = "http://somewhere.com/pello/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
