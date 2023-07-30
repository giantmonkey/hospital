# frozen_string_literal: true

class Patient
  extend Hospital::Doctor

  def self.check_check; end
end

class Patient2
  extend Hospital::Doctor

  checkup ->(doctor) do
    check_check
    doctor.add_warning('Something is strange.')
  end

  def self.check_check; end
end

class Patient3
  extend Hospital::Doctor

  checkup ->(doctor) do
    check_check
    doctor.add_warning('Something strange.')
    doctor.add_error('Something is VERY wrong.')
    doctor.add_info('Yay!')
  end

  def self.check_check; end
end

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital::Doctor do
    it "returns a warning if checkup not overwritten" do
      diagnosis = Hospital::Doctor.checkup(Patient)
      expect(diagnosis.warnings.map &:message).to eq ['Patient: No checks defined! Please call checkup with a lambda.']
    end

    it "returns doctors warnings if checkup overwritten" do
      diagnosis = Hospital::Doctor.checkup(Patient2)
      expect(diagnosis.warnings.map &:message).to eq ['Something is strange.']
    end

    it 'has the class name in the diagnosis' do
      diagnosis = Hospital::Doctor.checkup(Patient2)
      expect(diagnosis.name).to eq 'Patient2'
    end

    it 'makes sure it is not included' do
      expect do
        class Patty
          include Hospital::Doctor
        end
      end.to raise_error(Hospital::Error)
    end

    describe '.checkup_all' do
      it 'runs all checkups' do

        [Patient2, Patient3].each do |patient|
          expect(patient).to receive(:check_check)
        end

        Hospital::Doctor.checkup_all
      end
    end
  end
end
