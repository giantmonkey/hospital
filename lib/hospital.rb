# frozen_string_literal: true

require "byebug"
require_relative "hospital/version"
require_relative "hospital/checkup"
require_relative "hospital/checkup_group"
require_relative "hospital/diagnosis"
require_relative "hospital/formatter"

using Formatter

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  @@groups = []

  class << self

    def included(klass)
      raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
    end

    def do_checkup_all verbose: false
      errcount  = 0
      warcount  = 0

      @@groups.each do |group|
        puts group.header
        group.run_checkups verbose: verbose

        group.all_checkups.each do |checkup|
          if diagnosis = checkup.diagnosis
            errcount += diagnosis.errors.count
            warcount += diagnosis.warnings.count

            if !checkup.skipped
              puts "Checking #{diagnosis.name}:".h2.indented
              diagnosis.put_results
            elsif verbose
              puts "Skipped #{diagnosis.name}.".h2.indented
            end
          end
        end
      end

      puts <<~END

        #{"Summary:".h1}
        #{"Errors:   #{errcount}".red}
        #{"Warnings: #{warcount}".yellow}
      END
    end

    def find_or_create_checkup_group name
      unless checkup_group = @@groups.detect{|g| g.name == name }
        checkup_group = CheckupGroup.new name
        @@groups << checkup_group
      end
      checkup_group
    end
  end

  def checkup if: -> { true }, group: :general, title: nil, precondition: false, &code
    checkup_group = Hospital.find_or_create_checkup_group group
    checkup = Checkup.new(
      self,
      code,
      group:        group,
      title:        title,
      condition:    binding.local_variable_get('if'),
      precondition: precondition
    )

    # p "adding #{checkup.inspect} to #{group}"
    checkup_group.add_checkup checkup
  end
end
