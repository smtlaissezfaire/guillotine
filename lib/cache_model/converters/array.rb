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
  
  def map_paramaters(array=self.array)
    find_keys(array)
    yield @key, :==, array[1], not_condition
  end
  
private
  
  def not_condition
    SQLConditionConverter.convert(@condition)
  end
  
  def find_keys(array)
    array[0] =~ /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/
    
    @whole_matching_expression = $1
    @key = $2.strip
    @condition = $3.strip
  end
  
  class SQLConditionConverter
    def self.convert(string)
      converter = new(string)
      converter.convert
      converter.not_condition
    end
    
    def initialize(condition_string)
      @condition = condition_string.to_s
    end
    
    attr_reader :condition
    
    def convert
      if condition == "="
        @not_condition = false
      elsif condition == "!="
        @not_condition = true
      end
    end
    
    attr_reader :not_condition
  end
end
