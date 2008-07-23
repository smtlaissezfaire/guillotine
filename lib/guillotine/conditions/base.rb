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
  end
end
