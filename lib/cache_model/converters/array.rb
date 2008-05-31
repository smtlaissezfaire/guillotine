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
    each_statement do
      yield @key, :==, array[1], not_condition?
    end
  end
  
private
  
  def each_statement
    find_keys
    yield
  end
  
  def not_condition?
    @condition == "!=" ? true : false
  end
  
  def find_keys
    array[0] =~ /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/
    
    @whole_matching_expression = $1
    @key = $2.strip
    @condition = $3.strip
  end
end
