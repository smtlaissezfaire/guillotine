module Guillotine
  module Expressions    
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
  end
end