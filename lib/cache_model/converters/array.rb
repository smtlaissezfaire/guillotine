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
  
  def each_statement
    parsed_arrays.each do |key, value, negation|
      yield key, value, negation
    end
  end
  
  def parsed_arrays
    @parsed_arrays ||= sql_array_parser.parse
  end
  
  def sql_array_parser
    @sql_array_parser ||= SQLArrayParser.new(@array)
  end
  
  class SQLArrayParser
    REGEXP_MATCHER = /(([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?)/ unless defined?(REGEXP_MATCHER)
    
    def initialize(ar_array)
      @original_ar_array = ar_array
      @working_array = @original_ar_array.dup
    end
    
    attr_reader :working_array
    
    def parse(array = self.working_array, results=[])
      @working_array = array
      if expression.empty?
        results
      else
        parse_sql_statement
        parse(construct_new_array,
              results << [@current_key, @current_value, not_condition?])
      end
    end
    
  private
    
    def not_condition?
      @current_condition == "!="
    end
    
    def next_statement?
      more_to_process?
    end
    
    def more_to_process?
      expression.any?
    end
    
    def parse_sql_statement
      expression =~ REGEXP_MATCHER
      @matching_expression = $1
      @current_key = $2.strip
      @current_condition = $3.strip
      @current_value = first_value
    end
    
    def first_value
      working_array[1]
    end
    
    def construct_new_array
      [rest_of_expression, *rest_of_values]
    end
    
    def matching_expression
      @matching_expression ||= ""
    end
    
    def rest_of_expression
      regex = Regexp.new("(AND){0,1}\s*#{Regexp.escape(matching_expression)}", Regexp::IGNORECASE)
      expression.gsub(regex, "").strip
    end
    
    def expression
      @working_array[0]
    end
    
    def rest_of_values
      @working_array[2..@working_array.length-1]
    end
  end
end
