require_relative "formatter"

using Formatter

class Hospital::Diagnosis  
  attr_reader :infos, :warnings, :errors, :name, :results

  def initialize name
    @name = name.to_s
    reset
  end

  def reset
    @infos    = []
    @warnings = []
    @errors   = []
    @results  = []
  end

  def require_env_vars env_vars=[]
    success = true
    if (missing_vars = env_vars.select{|var| ENV[var].nil? || ENV[var].empty? }).any?
      add_error("These necessary ENV vars are not set: #{variable_list(missing_vars)}.")
      success = false
    else
      add_info("All necessary ENV vars are set.")
    end
  end

  def variable_list vars
    "[#{vars.map{|v| "'#{v}'"}.join(', ')}]"
  end

  def hide_value value
    "#{value}"
      .gsub(/(?<=.{1}).(?=.{2})/, '*')
      .gsub(/\*{10,}/, '*****...*****')
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
      puts output.indented
    end
  end

  class Info < Result
    def prefix; '🟢' end
  end

  class Warning < Result
    def prefix; '🟠' end
  end

  class Error < Result
    def prefix; '🔴' end
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

  def put_results
    results.each &:put
  end

  def on_success_message message
    if errors.count == 0
      add_info message
    end
  end
end
