class ArrayConditionConverter < ConditionConverter
  def initialize(array)
    @array = array
  end
  
  attr_reader :array
  
  def parse
    map_paramaters do |message, condition, value, negation| 
      lambdas << lambda do |obj|
        if negation
          obj.send(message) != value
        else
          obj.send(message).send(condition, value)
        end
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
      yield(key, :==, value, negation)
    end
  end
  
private
  
  def each_statement
    find_next_statement
    yield(@current_key, @current_value, not_condition?)
  end
  
  def not_condition?
    @current_condition == "!=" ? true : false
  end
  
  def find_next_statement
    array[0] =~ /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/
    
    @whole_matching_expression = $1
    @current_key = $2.strip
    @current_condition = $3.strip
    @current_value = array[1]
  end
end
