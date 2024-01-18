# frozen_string_literal: true

module Hospital
  class Checkup
    attr_reader :code, :condition, :diagnosis, :group, :skipped, :klass, :precondition

    def initialize klass, code, group: :general, title: nil, condition: -> { true }, precondition: false
      @klass        = klass
      @code         = code
      @group        = group
      @condition    = condition
      @diagnosis    = Hospital::Diagnosis.new([klass.to_s, title].compact.join(' - '))
      @precondition = precondition
    end

    def reset_diagnosis
      diagnosis.reset
    end

    def check verbose: false
      diagnosis.reset

      if condition.nil? || condition.call
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
  end
end
