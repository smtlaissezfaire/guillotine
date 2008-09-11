module Guillotine
  module Expressions
    class Equal < Base
      RUBY_OPERATOR = :==
      SQL_OPERATOR = "="
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class LessThan < Base
      RUBY_OPERATOR = :<
      SQL_OPERATOR  = RUBY_OPERATOR.to_s
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class GreaterThan < Base
      RUBY_OPERATOR = :>
      SQL_OPERATOR  = RUBY_OPERATOR.to_s
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class GreaterThanOrEqualTo < Base
      RUBY_OPERATOR = :>=
      SQL_OPERATOR  = RUBY_OPERATOR.to_s
      
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class LessThanOrEqualTo < Base
      RUBY_OPERATOR = :<=
      SQL_OPERATOR  = RUBY_OPERATOR.to_s
        
      def to_lambda
        new_lambda_with_comparison(RUBY_OPERATOR)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class NotEqual < Equal
      SQL_OPERATOR = "!="
      
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
    
    class IsNull < Base
      RUBY_OPERATOR = :nil?
      SQL_OPERATOR  = "IS NULL"
      
      def initialize(key)
        super(key, nil)
      end
      
      def to_lambda
        new_lambda_with_comparison(:==)
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR}"
      end
    end
    
    class IsNotNull < IsNull
      SQL_OPERATOR = "IS NOT NULL"
      
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR}"
      end
    end
  end
end
