# frozen_string_literal: true

RSpec.describe Hospital::Diagnosis do
  describe '.require_env_vars' do
    let (:diagnosis) { Hospital::Diagnosis.new('env var checker') } 

    before do
      allow(ENV).to receive(:[]).and_return(nil)
      allow(ENV).to receive(:[]).with('EXISTING').and_return('YEAH!')
    end

    it 'complains about missing ENV vars' do
      diagnosis.require_env_vars ['NOT_EXISTING']
      expect(diagnosis.errors.map &:message).to eq ["These necessary ENV vars are not set: ['NOT_EXISTING']."]
    end

    it 'reports existing ENV vars' do
      diagnosis.require_env_vars 
      expect(diagnosis.errors).to eq []
    end
  end
end
