# encoding: utf-8

require_relative '../../hospital'

desc 'check system setup sanity'
task :hospital => [] do
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  Hospital::Checkup.do
end
