module Guillotine
  module Expressions
    class Equal < Base
      RUBY_OPERATOR = :==
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
    end
    
    class LessThan < Base
      RUBY_OPERATOR = :<
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
    end
    
    class GreaterThan < Base
      RUBY_OPERATOR = :>
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
    end
    
    class GreaterThanOrEqualTo < Base
      RUBY_OPERATOR = :>=
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
    end
    
    class LessThanOrEqualTo < Base
      RUBY_OPERATOR = :<=
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
    end
    
    class NotEqual < Equal
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
    
    class IsNull < Base
      RUBY_OPERATOR = :nil?
      
      def initialize(key)
        super(key, nil)
      end
      
      def to_lambda
        new_lambda_with_comparison(:==)
      end
    end
    
    class IsNotNull < IsNull
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
  end
end
