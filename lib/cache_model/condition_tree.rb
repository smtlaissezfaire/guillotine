module CachedModel
  class ProperBinaryTree
    def initialize(*children)
      @children = children
      raise ArgumentError unless two_or_zero_children?
    end
    
    attr_reader :children
    
    def empty?
      children.empty?
    end
    
    alias_method :leaf?, :empty?
    alias_method :is_a_leaf?, :leaf?
    
  private
    
    def first_child
      children.first
    end
    
    def second_child
      if children
        children[1]
      else
        nil
      end
    end
    
    def second_child?
      second_child ? true : false
    end
    
    def two_or_zero_children?
      two_children? || zero_children?
    end
    
    def two_children?
      children.size == 2
    end
    
    alias_method :zero_children?, :leaf?
  end
  
  class ConditionNode < ProperBinaryTree
    def evaluate
      if first_child.empty? && second_child.empty?
        nil
      elsif first_child.empty?
        second_child.evaluate
      elsif second_child.empty?
        first_child.evaluate
      else
        evaluate_children
      end
    end
    
    def evaluate_children
      raise NotImplementedError, "Descendents of ConditionNode must implement the method evaluate_children"
    end
    
  end
  
  class ConjunctionConditionNode < ConditionNode
    def evaluate_children
      first_child.evaluate & second_child.evaluate
    end

  end
  
  class DisjunctionConditionNode < ConditionNode
    def evaluate_children
      first_child.evaluate | second_child.evaluate
    end
  end
end
