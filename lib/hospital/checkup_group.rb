require_relative "formatter"

using Formatter

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
      "\n### #{name.to_s.capitalize.gsub(/_/, ' ')} checks".h1
    end

    def add_checkup checkup
      if checkup.precondition
        @precondition_checkups << checkup
      else
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
