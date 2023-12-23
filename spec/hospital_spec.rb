# frozen_string_literal: true

class Patient
  extend Hospital

  def self.check_check; end
end

class Patient2
  extend Hospital

  checkup do |d|
    check_check
    d.add_warning('Something is strange.')
  end

  def self.check_check; end
end

class Patient3
  extend Hospital

  checkup do |d|
    check_check
    d.add_warning('Something strange.')
    d.add_error('Something is VERY wrong.')
    d.add_info('Yay!')
    d.require_env_vars ['MAMA']
  end

  def self.check_check; end
end

class Patient4
  extend Hospital

  checkup if: -> { false } do |d|
    check_check
    d.add_warning('I should not be called :-)')
  end

  def self.check_check; end
end

RSpec.describe Hospital do
  it "has a version number" do
    expect(Hospital::VERSION).not_to be nil
  end

  describe Hospital do
    it "returns a warning if checkup not overwritten" do
      diagnosis = Hospital.do_checkup(Patient)
      expect(diagnosis.warnings.map &:message).to eq ['Patient: No checks defined! Please call checkup with a lambda.']
    end

    it "returns checkups warnings if checkup overwritten" do
      diagnosis = Hospital.do_checkup(Patient2)
      expect(diagnosis.warnings.map &:message).to eq ['Something is strange.']
    end

    it 'has the class name in the diagnosis' do
      diagnosis = Hospital.do_checkup(Patient2)
      expect(diagnosis.name).to eq 'Patient2'
    end

    it 'executes require_env_vars method on the diagnosis' do
      diagnosis = Hospital.do_checkup(Patient3)
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

        [Patient2, Patient3].each do |patient|
          expect(patient).to receive(:check_check)
        end

        # Patient  has no checkup defined
        # Patient4 has the checkup disabled
        [Patient, Patient4].each do |patient|
          expect(patient).not_to receive(:check_check)
        end

        Hospital.do_checkup_all
      end
    end
  end
end
