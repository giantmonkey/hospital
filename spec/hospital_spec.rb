# frozen_string_literal: true

class Patient
  extend Hospital::Doctor
end

class Patient2
  extend Hospital::Doctor

  def self.do_checks
    diagnosis.add_warning('Something is VERY wrong.')
  end
end

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital::Doctor do
    it "returns a warning if checkup not overwritten" do
      diagnosis = Patient.checkup
      expect(diagnosis.warnings).to eq ['No checks defined! Please define your own self.do_checks.']
    end

    it "returns doctors warnings if checkup overwritten" do
      diagnosis = Patient2.checkup
      expect(diagnosis.warnings).to eq ['Something is VERY wrong.']
    end

    it 'has the class name in the diagnosis' do
      diagnosis = Patient2.checkup
      expect(diagnosis.name).to eq 'Patient2'
    end

    it 'makes sure it is not included' do
      expect do
        class Patient3
          include Hospital::Doctor
        end
      end.to raise_error(Hospital::Error)
    end
  end
end
