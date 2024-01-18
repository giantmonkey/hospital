# frozen_string_literal: true

require_rel 'classes'

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital do
    it "returns a warning if checkup not overwritten" do
      diagnosis = Hospital.do_checkup(PatientWithoutCheckup).first
      expect(diagnosis.warnings.map &:message).to eq ['PatientWithoutCheckup: No checks defined! Please call checkup with a lambda.']
    end

    it "returns checkups warnings if checkup overwritten" do
      diagnosis = Hospital.do_checkup(PatientWithCheckup).first
      expect(diagnosis.warnings.map &:message).to eq ['Something is strange.']
    end

    it 'has the class name in the diagnosis' do
      diagnosis = Hospital.do_checkup(PatientWithCheckup).first
      expect(diagnosis.name).to eq 'PatientWithCheckup'
    end

    it 'executes require_env_vars method on the diagnosis' do
      diagnosis = Hospital.do_checkup(PatientWithError).first
      expect(diagnosis.errors.map &:message).to eq [
        "Something is VERY wrong.",
        "These necessary ENV vars are not set: ['MAMA']."
      ]
    end

    it 'makes sure it is not included' do
      expect do
        class Patty
          include Hospital
        end
      end.to raise_error(Hospital::Error)
    end

    describe '.checkup_all' do
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

        Hospital.do_checkup_all
      end
    end

    describe 'multiple checkups' do
      it 'runs them all' do
        expect(PatientWithMultipleCheckups).to receive(:check_check1)
        expect(PatientWithMultipleCheckups).to receive(:check_check2)

        diagnosis = Hospital.do_checkup(PatientWithMultipleCheckups)
      end
    end
  end
end
