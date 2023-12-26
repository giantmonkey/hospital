# frozen_string_literal: true

require_relative "hospital/version"
require_relative "hospital/diagnosis"

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  class Checkup 
    attr_reader :code, :condition, :diagnosis, :group, :skipped, :klass

    def initialize klass, code, group: :general, title: nil, condition: -> { true }
      @klass      = klass
      @code       = code
      @group      = group
      @condition  = condition
      @diagnosis  = Hospital::Diagnosis.new([klass.to_s, title].compact.join(' - '))
    end

    def reset_diagnosis
      diagnosis.reset
    end

    def check verbose: false
      diagnosis.reset

      if condition.nil? || condition.call
        @skipped = false
        code.call(diagnosis)
        diagnosis
      else
        @skipped = true
        nil
      end
    rescue StandardError => e
      diagnosis.add_error "Unrescued exception in #{klass}.checkup:\n#{e.inspect}.\nThis is a bug inside the checkup method that should be fixed!"
    end
  end

  @@checkups = {}

  class << self
    def included(klass)
      raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
    end

    def extended(klass)
      # only relevant if the class does not yet define a real checkup method
      @@checkups[klass] = Checkup.new klass, -> (diagnosis) do
        diagnosis.add_warning("#{klass}: No checks defined! Please call checkup with a lambda.")
      end, group: :general
    end

    def do_checkup_all verbose: false
      errcount  = 0
      warcount  = 0

      threads = @@checkups.map do |klass, checkup|
        Thread.new do
          Thread.current.report_on_exception = false
          checkup.check(verbose: verbose)
        end
      end

      threads.each &:join

      @@checkups.group_by{|klass, checkup| checkup.group}.map do |group, checkups|
        puts "#{group == :general ? "\n" : "\n\n"}#{'#' * 30}\n### #{group.capitalize} checks"
        first = false

        checkups.each do |klass, checkup|
          if diagnosis = checkup.diagnosis
            errcount += diagnosis.errors.count
            warcount += diagnosis.warnings.count

            if !checkup.skipped
              puts "\n### Checking #{diagnosis.name}:"
              diagnosis.put_results
            elsif verbose
              puts "\n### Skipped #{diagnosis.name}."
            end
          end
        end
      end

      puts <<~END

        ### Summary:
        Errors:   #{errcount}
        Warnings: #{warcount}
      END
    end

    # used to call the checkup for a specific class directly (in specs)
    def do_checkup(klass)
      @@checkups[klass].check
    end
  end

  def checkup if: -> { true }, group: :general, title: nil, &code
    @@checkups[self] = Checkup.new self, code, group: group, title: title, condition: binding.local_variable_get('if')
  end

end
