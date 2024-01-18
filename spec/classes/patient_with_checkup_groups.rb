class PatientWithCheckupGroups
  extend Hospital

  checkup group: :some_group do |d|
    check_check1
  end

  checkup group: :other_group do |d|
    check_check2
  end

  def self.check_check1; end
  def self.check_check2; end
end
