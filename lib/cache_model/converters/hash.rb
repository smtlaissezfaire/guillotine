class HashConditionConverter < ConditionConverter
  def initialize(hash)
    @conditions = hash
  end
  
  attr_reader :conditions
  
  def parse
    @conditions.each do |key, value|
      lambdas << lambda do |obj|
        result = (obj.send(key) == value)
        result
      end
    end

    to_proc_array
  end
  
  def to_proc_array
    lambdas
  end
  
  def lambdas
    @lambdas ||= []
  end
end
