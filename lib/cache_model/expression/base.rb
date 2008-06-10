module CachedModel
  module Expression
    class Base
      def initialize(key, value)
        @key = key
        @value = value
      end
      
      attr_reader :key
      attr_reader :value
      
      def to_lambda
        raise NotImplementedError
      end
      
      def eql?(other)
        other.value == self.value && other.key == self.key
      end
      
      alias_method :==, :eql?
      
    private
      
      def new_lambda_with_comparison(comparison)
        lambda { |obj| obj.send(self.key).send(comparison, self.value) }
      end
    end
  end
end
