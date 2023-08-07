# lib/railtie.rb
require 'hospital'
require 'rails'

module Hospital
  class Railtie < Rails::Railtie
    railtie_name :hospital

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/hospital/tasks/*.rake").each { |f| load f }
    end
  end
end
