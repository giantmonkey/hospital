class PatientWithPreconditionAndDependent
  extend Hospital

  checkup group: :test_group, precondition: true do |d|
    check_precondition
    d.add_error 'precondition failed'
  end

  checkup group: :test_group do |d|
    check_dependent
    d.add_info 'dependent ran'
  end

  def self.check_precondition; end
  def self.check_dependent; end
end
