module Guillotine
  module Conditions
    class Base
      NOT_IMPLEMENTED_ERROR_MESSAGE = "Subclasses of Guillotine::Conditions::Base must implement to_sql"
      
      def initialize(child_one, child_two)
        @children = [child_one, child_two]
      end
      
      attr_reader :children
      
      def eql?(other)
        other.children == self.children && self.class == other.class
      end
      
      alias_method :==, :eql?
      
      def to_sql
        raise NotImplementedError, NOT_IMPLEMENTED_ERROR_MESSAGE
      end
      
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
