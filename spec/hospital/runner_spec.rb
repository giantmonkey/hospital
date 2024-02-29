# frozen_string_literal: true

RSpec.describe Hospital::Runner do
  let (:runner) { Hospital::Runner.new }

  describe '.do_checkup_all' do
    it 'runs all checkups' do

      [PatientWithCheckup, PatientWithError].each do |patient|
        expect(patient).to receive(:check_check)
      end

      # Patient                       has no checkup defined
      # PatientWithConditionalCheckup has the checkup disabled
      [PatientWithoutCheckup, PatientWithConditionalCheckup].each do |patient|
        expect(patient).not_to receive(:check_check)
      end

      expect(PatientWithCheckupGroups).not_to receive(:check_check1) # group precondition failed
      expect(PatientWithCheckupGroups).to     receive(:check_check2) # group precondition succeeded

      runner.do_checkup_all
    end
  end
end
