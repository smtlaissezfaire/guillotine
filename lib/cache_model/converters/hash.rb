class HashConditionConverter < ConditionConverter
  def initialize(hash)
    @hash = hash
  end
  
  attr_reader :hash
  
  def parse
    @lambda = lambda do |obj|
      result = false
      
      @hash.each do |key, value|
        result = (obj.send(key) == value)
      end
      
      result
    end
  end
end
