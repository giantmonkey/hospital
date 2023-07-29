# frozen_string_literal: true

require_relative "hospital/version"

module Hospital
  class Error < StandardError; end

  module Doctor

    def self.included(base)
      raise Error.new("Cannot include Hospital::Doctor, please extend instead.")
    end

    def self.extended(base)
      Hospital::Checkup.register(base)
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

  class Checkup
    @@classes = []

    class << self
      def register klass
        @@classes << klass
      end

      def do
        @@classes.each do |klass|
          klass.checkup
        end
      end
    end
  end

  class Diagnosis
    attr_reader :infos, :warnings, :errors, :name, :results

    def initialize name
      @name     = name
      @infos    = []
      @warnings = []
      @errors   = []
      @results  = []
    end

    class Result
      attr_reader :message, :prefix

      def initialize message
        @message = message
      end

      def output
        "#{prefix} #{message.gsub(/\n\z/, '').gsub(/\n/, prefix ? "\n   " : "\n")}"
      end

      def put 
        puts output
      end
    end

    class Info < Result
      def prefix; '🟢' end
    end

    class Warning < Result
      def prefix; '🟠'; end
    end

    class Error < Result
      def prefix; '🔴'; end
    end

    def add_info message
      info = Info.new message
      @infos    << info
      @results  << info
    end

    def add_warning message
      warning = Warning.new message
      @warnings << warning
      @results  << warning
    end

    def add_error message
      error = Error.new message
      @errors   << error
      @results  << error
    end

    private

    def put_header message
      puts ''
      puts "### #{message}"
    end

    def put_results
      put_header "Checking #{name}:"
      results.each &:put
    end
  end
end
