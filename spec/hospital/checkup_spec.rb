# frozen_string_literal: true

require 'hospital/checkup_group'

RSpec.describe Hospital::Checkup do
  class Patient; end
  class Dummy;   end

  let (:checkup) { Hospital::Checkup.new Patient, -> (diagnosis) { Dummy.new }, condition: -> { false } }

  it 'forces checkup on ignore condition' do
    expect(Dummy).to receive(:new)
    diagnosis = checkup.check ignore_condition: true
  end
end
