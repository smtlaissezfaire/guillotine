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
  
  attr_accessor :array
  
  def each_statement
    while next_statement?
      yield(@current_key, @current_value, not_condition?)
    end
  end
  
  def not_condition?
    @current_condition == "!="
  end
  
  REGEXP_MATCHER = /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/
  
  def next_statement?
    find_next_statement
  rescue
    false
  end
  
  def find_next_statement
    array[0] =~ REGEXP_MATCHER
    
    @whole_matching_expression = $1
    @current_key = $2.strip
    @current_condition = $3.strip
    @current_value = array[1]
    
    destruct_old_array
  end
  
  def destruct_old_array
    self.array = [rest_of_expression.strip, *rest_of_values]
  end
  
  def rest_of_expression
    array[0].gsub(@whole_matching_expression, "")
  end
  
  def rest_of_values
    array[2..array.length-1]
  end
end
