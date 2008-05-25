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
  
  def to_proc_array
    @lambdas
  end
  
  def lambdas
    @lambdas ||= []
  end
  
  def map_paramaters
    negation = false
    array[0] =~ /([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?/
    if $2 == "="
      condition = :==
    else
      condition = $2.strip
      if condition == "!="
        condition = :==
          not_condition = true
      end
    end
    
    yield $1.strip, condition, array[1], not_condition
  end
end
