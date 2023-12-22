# frozen_string_literal: true

require_relative "hospital/version"
require_relative "hospital/diagnosis"

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  @@groups      = {}
  @@checkups    = {}
  @@conditions  = {}
  @@diagnosises = {}

  def self.included(base)
    raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
  end

  def self.extended(base)
    @@checkups[base] = -> (diagnosis) do
      diagnosis.add_warning("#{base}: No checks defined! Please call checkup with a lambda.")
    end
    @@diagnosises[base] = Hospital::Diagnosis.new(base)
  end

  def checkup if: -> { true }, group: :general, &code
    @@conditions[self]  = binding.local_variable_get('if')
    @@groups[self]      = group
    @@checkups[self]    = code
  end

  def self.checkup klass
    diagnosis = @@diagnosises[klass]
    if @@conditions[klass].nil? || @@conditions[klass].call
      diagnosis.reset
      @@checkups[klass].call(diagnosis)
      diagnosis.put_results
    end
    diagnosis
  end

  def self.checkup_all
    errcount = 0
    @@checkups.keys.each do |klass|
      diagnosis = checkup(klass)
      errcount += diagnosis.errors.count
    end

    puts <<~END

      Summary:
      Errors:   #{errcount}
      Warnings: #{errcount}
    END
  end
end
