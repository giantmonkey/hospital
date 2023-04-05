# frozen_string_literal: true

require_relative "hospital/version"

module Hospital
  class Error < StandardError; end

  module Doctor

    def self.included(base)
      raise Error.new("Cannot include Hospital::Doctor, please extend instead.")
    end

    def checkup
      do_checks
      diagnosis
    end

    private

    def do_checks
      diagnosis.add_warning('No checks defined! Please define your own self.do_checks.')
    end

    def diagnosis
      @diagnosis ||= Diagnosis.new(self.name)
    end
  end

  class Diagnosis
    attr_reader :infos, :warnings, :errors, :name

    def initialize name
      @name     = name
      @infos    = []
      @warnings = []
      @errors   = []
    end

    def add_warning warning
      @warnings << warning
    end
  end
end
