module Guillotine
  module Expressions    
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