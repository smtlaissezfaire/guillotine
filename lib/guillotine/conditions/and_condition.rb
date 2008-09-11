module Guillotine
  module Conditions
    class AndCondition < Base
      SQL_OPERATOR = "AND"
      
      # If we can a-priori figure out whether call one or call two 
      # returns fewer records, we'll be building a real in-memory database!
      def call(collection)
        return [] if collection.empty?
        results_of_first_call = first_child.call(collection)
        results_of_first_call & second_child.call(results_of_first_call)
      end
      
      def to_sql
        "#{first_child.to_sql} #{SQL_OPERATOR} #{second_child.to_sql}"
      end
    end
  end
end
