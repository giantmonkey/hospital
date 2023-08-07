# encoding: utf-8

require_relative '../../hospital'

desc 'Check system setup sanity.'
task :doctor => [] do
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  Hospital.checkup_all
end
