# frozen_string_literal: true

require "byebug"
require_relative "hospital/version"
require_relative "hospital/diagnosis"
require_relative "hospital/formatter"

using Formatter

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
      diagnosis.add_error "Unrescued exception in #{klass}.checkup:\n#{e.full_message}.\nThis is a bug inside the checkup method that should be fixed!"
    end
  end

  @@checkups = {}

  class << self

    def included(klass)
      raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
    end

    def extended(klass)
      # only relevant if the class does not yet define a real checkup method
      @@checkups[klass] = []
    end

    def do_checkup_all verbose: false
      errcount  = 0
      warcount  = 0

      threads = @@checkups.keys.map do |klass|
        Thread.new do
          Thread.current.report_on_exception = false
          do_checkup(klass, verbose: verbose)
        end
      end

      threads.each &:join

      @@checkups.values.flatten.group_by(&:group).map do |group, checkups|
        puts group_header(group)
        first = false

        checkups.each do |checkup|
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

    # used to call the checkup for a specific class directly (in specs)
    def do_checkup(klass, verbose: false)
      if @@checkups[klass].length > 0
        @@checkups[klass].map do |cu|
          cu.check verbose: verbose
        end
      else
        diagnosis = Diagnosis.new(klass)
        diagnosis.add_warning("#{klass}: No checks defined! Please call checkup with a lambda.")
        [ diagnosis ]
      end
    end

    def group_header group
      "### #{group.to_s.capitalize.gsub(/_/, ' ')} checks".h1
    end
  end

  def checkup if: -> { true }, group: :general, title: nil, &code
    @@checkups[self] ||= []
    @@checkups[self] << Checkup.new(
      self,
      code,
      group: group,
      title: title,
      condition: binding.local_variable_get('if')
    )
  end
end
