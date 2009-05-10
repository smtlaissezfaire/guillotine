module Guillotine
  module Expressions    
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
  end
end