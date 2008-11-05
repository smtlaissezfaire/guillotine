module Guillotine
  module Conditions
    class OrCondition < Base
      SQL_OPERATOR = "OR"
      
      def call(collection)
        if collection.empty?
          []
        else
          results_of_first_call = first_child.call(collection)
          results_of_first_call | second_child.call(collection)
        end
      end
      
      def to_sql
        "(#{first_child.to_sql} #{SQL_OPERATOR} #{second_child.to_sql})"
      end
    end
  end
end
