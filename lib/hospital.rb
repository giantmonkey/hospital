# frozen_string_literal: true

require_relative "hospital/version"
require_relative "hospital/diagnosis"

module Hospital
  require_relative 'railtie' if defined?(Rails)

  class Error < StandardError; end

  @@checkups    = {}
  @@diagnosises = {}

  def self.included(base)
    raise Hospital::Error.new("Cannot include Hospital, please extend instead.")
  end

  def self.extended(base)
    @@checkups[base] = ->(diagnosis) do
      diagnosis.add_warning("#{base}: No checks defined! Please call checkup with a lambda.")
    end
    @@diagnosises[base] = Hospital::Diagnosis.new(base)
  end

  def checkup code
    @@checkups[self] = code
  end

  def self.checkup klass
    @@diagnosises[klass].reset
    @@checkups[klass].call(@@diagnosises[klass])
    @@diagnosises[klass]
  end

  def self.checkup_all
    errcount = 0
    @@checkups.keys.each do |klass|
      checkup(klass)
      diagnosis = @@diagnosises[klass]
      diagnosis.put_results
      errcount += diagnosis.errors.count
    end

    puts <<~END

      Summary:
      Errors: #{errcount}
    END
  end
end
