# encoding: utf-8

require_relative '../../hospital'

desc 'Check system setup sanity.'
task :doctor, [:verbose] => :environment do |t, args|
  # at_exit { Rake::Task['doctor:summary'].invoke if $!.nil? }

  ActiveRecord::Base.connection_pool.disconnect!
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env]
    config['pool'] = 100
    ActiveRecord::Base.establish_connection(config)
  end
  
  verbose = args[:verbose] == "true"

  # silence warnings about double constant definitions
  Kernel::silence_warnings do
    p "eager load all classes" if verbose
    Rails.application.eager_load!
  end
  
  p "start checkup" if verbose
  Hospital.do_checkup_all verbose: verbose
end
