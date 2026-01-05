# frozen_string_literal: true

require_rel 'classes'

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital do
    describe '#do_checkup' do
      xit "returns a warning if checkup not overwritten" do
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

      it 'allows for condition to be ignored' do
        diagnosis = Hospital.do_checkup(PatientWithConditionalCheckup, ignore_condition: true).first
        expect(diagnosis.warnings.map &:message).to eq [
          "I should not be called :-)"
        ]
      end

      it 'still returns diagnosis on exception' do
        diagnosis =  Hospital.do_checkup(PatientWithException).first

        expect(diagnosis).to be_a Hospital::Diagnosis
      end
    end

    it 'makes sure it is not included' do
      expect do
        class Patty
          include Hospital
        end
      end.to raise_error(Hospital::Error)
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
