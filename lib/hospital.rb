# frozen_string_literal: true

require_relative "hospital/version"
require_relative "hospital/diagnosis"

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  class Checkup 
    attr_reader :code, :condition, :diagnosis, :group

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
        code.call(diagnosis)
        diagnosis
      else
        if verbose
          diagnosis.add_info 'Skipped because condition not met.'
          diagnosis
        else
          nil
        end
      end
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
      threads   = []

      @@checkups.each do |klass, checkup|
        threads << Thread.new do
          Thread.current.report_on_exception = false
          checkup.check(verbose: verbose)
        end
      end

      begin
        threads.each &:join
      rescue StandardError => e
        p e
      end

      @@checkups.group_by{|klass, checkup| checkup.group}.map do |group, checkups|
        puts "#{group == :general ? "\n" : "\n\n"}#{'#' * 30}\n### #{group.capitalize} checks"
        first = false

        checkups.each do |klass, checkup|
          if diagnosis = checkup.diagnosis
            errcount += diagnosis.errors.count
            warcount += diagnosis.warnings.count
            diagnosis.put_results
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
