# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
Rake.add_rakelib "./lib/hospital/tasks"

RSpec::Core::RakeTask.new(:spec)

task default: :spec
