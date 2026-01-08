# frozen_string_literal: true

require_rel '../classes'

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

    describe 'Hash / JSON formatter' do
      let (:runner) { Hospital::Runner.new(formatter: :raw) }

      it 'spits out JSON' do
        result = runner.do_checkup_all
        expect(result['summary']['errors']).to eq 5
        expect(result['summary']['infos']).to eq 2
      end

      it 'returns structured results with type and message' do
        result = runner.do_checkup_all
        diagnosis_results = result['General checks']['PatientWithCheckup:']
        expect(diagnosis_results).to include(
          { 'type' => 'warning', 'message' => 'Something is strange.' }
        )
      end

      it 'includes all groups in output' do
        result = runner.do_checkup_all
        group_names = result.keys - ['summary']
        expect(group_names).to contain_exactly(
          'General checks',
          'Some group checks',
          'Other group checks',
          'Test group checks'
        )
      end

      it 'includes empty diagnoses with empty array' do
        result = runner.do_checkup_all
        # PatientWithMultipleCheckups has two checkups that add no results
        expect(result['General checks']).to have_key('PatientWithMultipleCheckups:')
        expect(result['General checks']['PatientWithMultipleCheckups:']).to eq []
      end

      it 'includes skipped diagnoses with skipped flag' do
        result = runner.do_checkup_all
        # PatientWithCheckupGroups check_check1 is in :some_group which has a failed precondition
        expect(result['Some group checks']).to have_key('PatientWithCheckupGroups:')
        expect(result['Some group checks']['PatientWithCheckupGroups:']).to eq({ 'skipped' => true })
      end
    end
  end
end
