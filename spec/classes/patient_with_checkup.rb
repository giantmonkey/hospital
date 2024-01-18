class PatientWithCheckup
  extend Hospital

  checkup do |d|
    check_check
    d.add_warning('Something is strange.')
  end

  def self.check_check; end
end
