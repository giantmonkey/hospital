# frozen_string_literal: true

RSpec.describe Hospital::Diagnosis do
  let (:diagnosis) { Hospital::Diagnosis.new('env var checker') }

  before do
    allow(ENV).to receive(:[]).and_return(nil)
    allow(ENV).to receive(:[]).with('EXISTING').and_return('YEAH!')
    allow(ENV).to receive(:[]).with('PASSWORD').and_return('very secret')
  end

  describe '.require_env_vars' do
    it 'complains about missing ENV vars' do
      diagnosis.require_env_vars ['NOT_EXISTING']
      expect(diagnosis.errors.map &:message).to eq ["These necessary ENV vars are not set: ['NOT_EXISTING']."]
    end

    it 'reports existing ENV vars' do
      diagnosis.require_env_vars ['EXISTING']
      expect(diagnosis.errors).to eq []
    end
  end

  describe '#dump_required_env_vars' do
    it 'dumps the env vars in a safe way' do
      diagnosis.require_env_vars ['EXISTING', 'PASSWORD']
      expect(diagnosis.dump_required_env_vars).to eq "'EXISTING': YEAH!,\n'PASSWORD': v********et"
    end
  end
end
