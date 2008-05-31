class ArrayConditionConverter < ConditionConverter
  def initialize(array)
    @array = array
  end
  
  def parse
    map_paramaters do |message, value, negation| 
      lambdas << lambda do |obj|
        equal_result = obj.send(message) == value
        negation ? !equal_result : equal_result
      end
    end
    
    to_proc_array
  end
  
  def lambdas
    @lambdas ||= []
  end
  
  alias_method :to_proc_array, :lambdas
  
  def map_paramaters
    each_statement do |key, value, negation|
      yield(key, value, negation)
    end
  end
  
private
  
  attr_reader :array
  
  def each_statement
    find_next_statement
    yield(@current_key, @current_value, not_condition?)
  end
  
  def not_condition?
    @current_condition == "!="
  end
  
  def find_next_statement
    array[0] =~ /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/
    
    @whole_matching_expression = $1
    @current_key = $2.strip
    @current_condition = $3.strip
    @current_value = array[1]
  end
end
