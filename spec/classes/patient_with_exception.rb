class PatientWithException
  extend Hospital

  checkup do |d|
    raise 'hell'
  end
end
