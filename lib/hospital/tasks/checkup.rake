# encoding: utf-8

require_relative '../../hospital'

class Test
  extend Hospital

  checkup -> (doctor) do
    doctor.add_warning 'nonono'
    doctor.add_error 'nonono!!!!'
    doctor.add_info 'nonono!!!!'
  end
end

class Test2
  extend Hospital

  checkup -> (doctor) do
    doctor.add_error 'nonono!!!!'
  end
end

desc 'check system setup sanity'
task :doctor => [] do
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  Hospital.checkup_all
end
