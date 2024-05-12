# frozen_string_literal: true

module Hospital
  class Checkup
    attr_reader :code, :condition, :diagnosis, :group, :skipped, :klass, :precondition

    def initialize klass, code, title: nil, condition: -> { true }, precondition: false
      @klass        = klass
      @code         = code
      @condition    = condition
      @diagnosis    = Hospital::Diagnosis.new([klass.to_s, title].compact.join(' - '))
      @precondition = precondition
      @group        = nil
    end

    def reset_diagnosis
      diagnosis.reset
    end

    def check verbose: false, ignore_condition: false
      diagnosis.reset

      if ignore_condition || condition.nil? || condition.call
        @skipped = false
        code.call(diagnosis)
        diagnosis
      else
        @skipped = true
        nil
      end
    rescue StandardError => e
      diagnosis.add_error "Unrescued exception in #{klass}.checkup:\n#{e.full_message}.\nThis is a bug inside the checkup method that should be fixed!"
    end

    def success?
      diagnosis.success?
    end

    def set_group group
      @group = group
    end
  end
end
