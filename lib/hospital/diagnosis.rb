class Diagnosis  
  attr_reader :name, :results

  def initialize name, required_env_vars: []
    @name               = name
    @results            = []
    @required_env_vars  = required_env_vars

    check_required_env_vars if required_env_vars.any?
  end

  def check_required_env_vars
    if (missing_vars = @required_env_vars.select{|var| ENV[var].blank? }).any?
      add_error("These necessary ENV vars are not set: #{variable_list(missing_vars)}.")
    else
      add_success("All necessary ENV vars are set.")
    end
  end

  def variable_list vars
    "[#{vars.map{|v| "'#{v}'"}.join(', ')}]"
  end

  def add_error error
    @results << {type: :error, message: error}
  end

  def add_warning warning
    @results << {type: :warning, message: warning}
  end

  def add_success success
    @results << {type: :success, message: success}
  end
end
