# encoding: utf-8

require_relative '../../hospital'

class Test
  extend Hospital::Doctor

  def self.do_checks
    diagnosis.add_warning 'nonono'
    diagnosis.add_error 'nonono!!!!'
    diagnosis.add_info 'nonono!!!!'
  end
end

class Test2
  extend Hospital::Doctor

  def self.do_checks
    diagnosis.add_error 'nonono!!!!'
  end
end

desc 'check system setup sanity'
task :doctor => [] do
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  Hospital::Doctor.checkup_all
end
