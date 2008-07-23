module Guillotine
  module Conditions
    dir = File.dirname(__FILE__) + "/conditions"
    
    autoload :Base, "#{dir}/base"
    
    class AndCondition < Base
      # If we can a-priori figure out whether call one or call two 
      # returns fewer records, we'll be building a real in-memory database!
      def call(collection)
        return [] if collection.empty?
        results_of_first_call = first_child.call(collection)
        results_of_first_call & second_child.call(results_of_first_call)
      end
    end
    
    class OrCondition < Base
      def call(collection)
        return [] if collection.empty?
        results_of_first_call = first_child.call(collection)
        results_of_first_call | second_child.call(collection)
      end
    end
  end
end
