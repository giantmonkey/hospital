# frozen_string_literal: true

require_relative "lib/hospital/version"

Gem::Specification.new do |spec|
  spec.name     = "hospital"
  spec.version  = Hospital::VERSION
  spec.authors  = ["Alexander"]
  spec.email    = ["alexander@presber.net"]

  spec.summary                = "A framwork for app self-checks"
  spec.description            = "Imagine a team of little doctors creating diagnoses and creating a useful report."
  spec.homepage               = "https://github.com/giantmonkey/hospital"
  spec.license                = "MIT"
  spec.required_ruby_version  = ">= 3.4.8"

  # spec.metadata["allowed_push_host"]  = "'https://rubygems.org'"

  spec.metadata["homepage_uri"]       = spec.homepage
  spec.metadata["source_code_uri"]    = "https://github.com/giantmonkey/hospital"
  spec.metadata["changelog_uri"]      = "https://github.com/giantmonkey/hospital/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("{bin,lib,template}/**/*") + %w(LICENSE.txt README.md)
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "byebug"
  spec.add_development_dependency "require_all"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
