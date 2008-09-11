module Guillotine
  module Expressions
    class Equal < Base
      def to_lambda
        new_lambda_with_comparison(:==)
      end
    end
    
    class LessThan < Base
      def to_lambda
        new_lambda_with_comparison(:<)
      end
    end
    
    class GreaterThan < Base
      def to_lambda
        new_lambda_with_comparison(:>)
      end
    end
    
    class GreaterThanOrEqualTo < Base
      def to_lambda
        new_lambda_with_comparison(:>=)
      end
    end
    
    class LessThanOrEqualTo < Base
      def to_lambda
        new_lambda_with_comparison(:<=)
      end
    end
    
    class NotEqual < Equal
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
    
    class IsNull < Base
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
