module Guillotine
  module Expressions    
    class NotEqual < Equal
      SQL_OPERATOR = "!="
      
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
      
      def to_sql
        "#{key} #{SQL_OPERATOR} #{value}"
      end
    end
  end
end