module CachedModel
  class BackTickString
    class InvalidString < StandardError; end
    
    BACK_TICK = "`" unless defined?(BACK_TICK)
    
    def initialize(string)
      @string = string
      check_string_for_backticks
    end
    
    def value
      @value ||= @string.gsub("`", "")
    end
    
  private
    
    def check_string_for_backticks
      if @string.first != BACK_TICK || @string.last != BACK_TICK
        raise InvalidString, "The string '#{@string}' is not a valid backticked string"
      end
    end
  end
end
