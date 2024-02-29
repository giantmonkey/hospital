# frozen_string_literal: true

require "byebug"
require          'require_all'
require_relative "hospital/version"
require_relative "hospital/checkup"
require_relative "hospital/checkup_group"
require_relative "hospital/diagnosis"
require_relative "hospital/string_formatter"
require_relative "hospital/formatter/shell"

using StringFormatter

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  @@groups = []

  class << self

    def included(klass)
      raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
    end

    # used to call the checkup for a specific class directly (in specs)
    def do_checkup(klass, verbose: false)
      @@groups.map(&:all_checkups).flatten.select{|cu| cu.klass == klass }.map do |cu|
        cu.check verbose: verbose
      end
    end

    def find_or_create_checkup_group name
      unless checkup_group = @@groups.detect{|g| g.name == name }
        checkup_group = CheckupGroup.new name
        @@groups << checkup_group
      end
      checkup_group
    end

    def groups
      @@groups
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

  class Runner
    attr_reader :verbose

    def initialize verbose: false, formatter: Formatter::Shell
      @verbose    = verbose
      @formatter  = formatter
    end

    def do_checkup_all
      out = @formatter.new

      errcount  = 0
      warcount  = 0

      Hospital.groups.each do |group|
        out.put_group_header group.header
        group.run_checkups verbose: verbose

        group.all_checkups.each do |checkup|
          if diagnosis = checkup.diagnosis
            errcount += diagnosis.errors.count
            warcount += diagnosis.warnings.count

            if !checkup.skipped
              out.put_diagnosis_header "Checking #{diagnosis.name}:".h2.indented
              diagnosis.put_results
            elsif verbose
              out.put_diagnosis_header "Skipped #{diagnosis.name}.".h2.indented
            end
          end
        end
      end

      out.put_summary errcount, warcount

      out.buffer
    end

  end
end
