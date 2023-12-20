class Hospital::Diagnosis  
  attr_reader :infos, :warnings, :errors, :name, :results

  def initialize name
    @name               = name.to_s
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

  def put_results
    put_header "Checking #{name}:"
    results.each &:put
  end

  private

  def put_header message
    puts ''
    puts "### #{message}"
  end

end
