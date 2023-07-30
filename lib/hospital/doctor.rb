require_relative "diagnosis"

module Hospital::Doctor
  @@checkups    = {}
  @@diagnosises = {}

  def self.included(base)
    raise Hospital::Error.new("Cannot include Hospital::Doctor, please extend instead.")
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
    @@checkups.keys.each do |klass|
      checkup(klass)
      @@diagnosises[klass].put_results
    end
  end
end
