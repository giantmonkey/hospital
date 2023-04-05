require_relative "diagnosis"

module Hospital::Doctor
  @@classes = []

  def self.included(base)
    raise Hospital::Error.new("Cannot include Hospital::Doctor, please extend instead.")
  end

  def self.extended(base)
    @@classes << base
  end

  def checkup
    diagnosis.reset
    do_checks
    diagnosis
  end

  def self.checkup_all
    @@classes.each do |klass|
      diagnosis = klass.checkup
      diagnosis.put_results
    end
  end

  def reset
    @@classes = []
  end

  private

  def do_checks
    diagnosis.add_warning('No checks defined! Please define your own self.do_checks.')
  end

  def diagnosis
    @diagnosis ||= Hospital::Diagnosis.new(self.name)
  end
end

