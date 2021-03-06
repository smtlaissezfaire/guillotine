module Guillotine
  module Expressions
    class Base
      def initialize(key, value)
        @key = key
        @value = value
      end
      
      attr_reader :key
      attr_reader :value
      
      def eql?(other)
        self.class == other.class &&
        other.key == self.key &&
        other.value == self.value
      end
      
      alias_method :==, :eql?
      
      def call(collection)
        collection.select { |obj| self.to_lambda.call(obj) }
      end
      
      def to_sql
        raise NotImplementedError, "Subclasses of Guillotine::Expression::Base must implement #to_sql"
      end
      
    private
      
      def new_lambda_with_comparison(comparison)
        lambda { |obj| obj[key_as_symbol].send(comparison, self.value) }
      end
      
      def key_as_symbol
        key.to_sym
      end
    end
  end
end
