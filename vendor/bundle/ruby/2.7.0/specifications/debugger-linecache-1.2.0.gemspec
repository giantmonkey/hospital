# -*- encoding: utf-8 -*-
# stub: debugger-linecache 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "debugger-linecache".freeze
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["R. Bernstein".freeze, "Mark Moseley".freeze, "Gabriel Horner".freeze]
  s.date = "2013-03-11"
  s.description = "Linecache is a module for reading and caching lines. This may be useful for\nexample in a debugger where the same lines are shown many times.\n".freeze
  s.email = "gabriel.horner@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://github.com/cldwalker/debugger-linecache".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "Read file with caching".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 0.9.2.2"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 0.9.2.2"])
  end
end
