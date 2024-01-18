class PatientWithConditionalCheckup
  extend Hospital

  checkup if: -> { false } do |d|
    check_check
    d.add_warning('I should not be called :-)')
  end

  def self.check_check; end
end
