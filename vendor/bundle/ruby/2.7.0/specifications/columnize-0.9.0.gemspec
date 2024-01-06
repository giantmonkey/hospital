# -*- encoding: utf-8 -*-
# stub: columnize 0.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "columnize".freeze
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Rocky Bernstein".freeze]
  s.date = "2014-12-05"
  s.description = "\nIn showing a long lists, sometimes one would prefer to see the value\narranged aligned in columns. Some examples include listing methods\nof an object or debugger commands.\nSee Examples in the rdoc documentation for examples.\n".freeze
  s.email = "rockyb@rubyforge.net".freeze
  s.extra_rdoc_files = ["README.md".freeze, "lib/columnize.rb".freeze, "COPYING".freeze, "THANKS".freeze]
  s.files = ["COPYING".freeze, "README.md".freeze, "THANKS".freeze, "lib/columnize.rb".freeze]
  s.homepage = "https://github.com/rocky/columnize".freeze
  s.licenses = ["Ruby".freeze, "GPL2".freeze]
  s.rdoc_options = ["--main".freeze, "README".freeze, "--title".freeze, "Columnize 0.9.0 Documentation".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Module to format an Array as an Array of String aligned in columns".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.1.0"])
  else
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.1.0"])
  end
end
