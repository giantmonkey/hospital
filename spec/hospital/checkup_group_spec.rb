# frozen_string_literal: true

require 'hospital/checkup_group'

RSpec.describe Hospital::CheckupGroup do
  let (:success)          { -> (d) { d.add_info 'nice!'} }
  let (:failure)          { -> (d) { d.add_error 'fail!'} }
  let (:group)            { Hospital::CheckupGroup.new :test }
  let (:checkup_normal)   { Hospital::Checkup.new(Object, success) }
  let (:checkup_pre)      { Hospital::Checkup.new(Object, success, precondition: true) }
  let (:checkup_pre_fail) { Hospital::Checkup.new(Object, failure, precondition: true) }

  before do
    group.add_checkup checkup_normal
    group.add_checkup checkup_pre
  end

  describe '#add_checkup' do
    it 'sorts checkups and preconditions' do
      expect(group.checkups).to              eq [checkup_normal]
      expect(group.precondition_checkups).to eq [checkup_pre]
    end
  end

  describe '#run_precondition_checkups' do
  end

  describe '#run_dependent_checkups' do
  end

  describe '#run_checkups' do
    describe 'preconditions succeed' do
      it 'calls precondition checkups then rest' do
        expect(group).to receive(:run_precondition_checkups).ordered.and_call_original
        expect(group).to receive(:run_dependent_checkups).ordered.and_call_original

        group.run_checkups
      end
    end

    describe 'preconditions (partially) fail' do
      before do
        group.add_checkup checkup_pre_fail
      end

      it 'does not run dependent checkups if precondition fails' do
        expect(group).to     receive(:run_precondition_checkups).and_call_original
        expect(group).not_to receive(:run_dependent_checkups)

        group.run_checkups
      end
    end
  end
end
