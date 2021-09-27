# frozen_string_literal: true

require_relative 'lib/pirb_cli/version'

Gem::Specification.new do |spec|
  spec.name = 'pirb-cli'
  spec.version = PirbCli::VERSION
  spec.authors = ['Lucas M']

  spec.summary = 'Pomodoro Timer in Ruby - CLI Version'
  spec.description = 'Pomodoro Timer in Ruby - CLI Version '
  spec.homepage = 'https://github.com/lucasmenezesds/pomodoro-in-ruby-cli'
  spec.license = 'MIT'
  spec.required_ruby_version = '~> 3.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
