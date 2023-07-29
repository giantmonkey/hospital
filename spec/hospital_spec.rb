# frozen_string_literal: true

class Patient
  extend Hospital::Doctor
end

class Patient2
  extend Hospital::Doctor

  def self.do_checks
    diagnosis.add_warning('Something is strange.')
  end
end

class Patient3
  extend Hospital::Doctor

  def self.do_checks
    diagnosis.add_warning('Something strange.')
    diagnosis.add_error('Something is VERY wrong.')
    diagnosis.add_info('Yay!')
  end
end

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital::Checkup do
    describe '.checkup' do
      it 'runs all checkups' do

        [Patient, Patient2].each do |patient|
          expect(patient).to receive(:checkup)
        end

        Hospital::Checkup.do
      end
    end
  end

  describe Hospital::Doctor do
    it "returns a warning if checkup not overwritten" do
      diagnosis = Patient.checkup
      expect(diagnosis.warnings.map &:message).to eq ['No checks defined! Please define your own self.do_checks.']
    end

    it "returns doctors warnings if checkup overwritten" do
      diagnosis = Patient2.checkup
      expect(diagnosis.warnings.map &:message).to eq ['Something is strange.']
    end

    it 'has the class name in the diagnosis' do
      diagnosis = Patient2.checkup
      expect(diagnosis.name).to eq 'Patient2'
    end

    it 'makes sure it is not included' do
      expect do
        class Patty
          include Hospital::Doctor
        end
      end.to raise_error(Hospital::Error)
    end
  end
end
