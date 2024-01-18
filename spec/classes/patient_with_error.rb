class PatientWithError
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
