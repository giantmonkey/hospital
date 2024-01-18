class PatientWithCheckupGroupPrecondition
  extend Hospital

  checkup group: :some_group, precondition: true do |d|
    check_check1
    d.add_error 'failed precondition.'
  end

  checkup group: :other_group, precondition: true do |d|
    check_check2
    d.add_info 'succeeded precondition.'
  end

  def self.check_check1; end
  def self.check_check2; end
end
