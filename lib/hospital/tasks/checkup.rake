# encoding: utf-8

require_relative '../../hospital'

desc 'Check system setup sanity.'
task :doctor, [:verbose] => :environment do |t, args|
  verbose = args[:verbose] == "true"

  # silence warnings about double constant definitions
  Kernel::silence_warnings do
    p "eager load all classes" if verbose
    Rails.application.eager_load!
  end

  p "start checkup" if verbose
  puts Hospital.do_checkup_all verbose: verbose
end
