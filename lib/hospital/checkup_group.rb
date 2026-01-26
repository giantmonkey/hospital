require_relative "string_formatter"

using StringFormatter

module Hospital
  class CheckupGroup
    attr_reader :name, :checkups, :precondition_checkups, :skipped

    def initialize name
      @name                   = name
      @precondition_checkups  = []
      @checkups               = []
      @skipped                = false
    end

    def all_checkups
      @precondition_checkups + @checkups
    end

    def header
      "#{name.to_s.capitalize.gsub(/_/, ' ')} checks"
    end

    def add_checkup checkup
      source_location = checkup.code.source_location

      if checkup.precondition
        if @precondition_checkups.any? { |cu| cu.code.source_location == source_location }
          warn "Hospital: Skipping duplicate precondition checkup '#{checkup.diagnosis.name}' in group '#{name}'"
          return
        end
        checkup.set_group self
        @precondition_checkups << checkup
      else
        if @checkups.any? { |cu| cu.code.source_location == source_location }
          warn "Hospital: Skipping duplicate checkup '#{checkup.diagnosis.name}' in group '#{name}'"
          return
        end
        checkup.set_group self
        @checkups << checkup
      end
    end

    def run_checkups verbose: false
      run_precondition_checkups verbose: verbose

      unless @skipped
        run_dependent_checkups verbose: verbose
      end
    end

    def run_precondition_checkups verbose: false
      @precondition_checkups.each do |checkup|
        checkup.check verbose: verbose
        @skipped = true unless checkup.success?
      end
    end

    def run_dependent_checkups verbose: false
      @checkups.each do |checkup|
        checkup.check verbose: verbose
      end
    end
  end
end
