class ConditionConverter
  class << self
    def parse(hash_or_array)
      new_subtype(hash_or_array).parse
    end
    
    def new_subtype(hash_or_array)
      case hash_or_array
      when Array
        ArrayConditionConverter.new(hash_or_array)
      when Hash
        HashConditionConverter.new(hash_or_array)
      end
    end
  end
  
  def to_proc
    @lambda
  end
end
