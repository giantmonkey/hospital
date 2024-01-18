class PatientWithMultipleCheckups
  extend Hospital

  checkup do |d|
    check_check1
  end

  checkup do |d|
    check_check2
  end

  def self.check_check1; end
  def self.check_check2; end
end
