module Guillotine
  module Conditions
    class Base
      def initialize(child_one, child_two)
        @children = [child_one, child_two]
      end
      
      attr_reader :children
      
      def eql?(other)
        other.children == self.children && self.class == other.class
      end
      
      alias_method :==, :eql?
      
      private
      
      def first_child
        children.first
      end
      
      def second_child
        children[1]
      end
    end
    
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
