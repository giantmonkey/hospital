# encoding: utf-8

require_relative '../../hospital'

desc 'Check system setup sanity.'
task :doctor => :environment do
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  # silence warnings about double constant definitions
  Kernel::silence_warnings do
    Rails.application.eager_load!
  end

  Hospital.do_checkup_all
end
