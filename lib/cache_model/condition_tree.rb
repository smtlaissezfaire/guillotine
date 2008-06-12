module CachedModel
  class ProperBinaryTree
    def initialize(child_one, child_two)
      @children = [child_one, child_two]
    end
    
    attr_reader :children
    
  private
    
    def first_child
      children.first
    end
    
    def second_child
      children[1]
    end
    
    def two_children?
      children.size == 2
    end
  end
  
  class ConditionNode < ProperBinaryTree
    def evaluate
      raise NotImplementedError, "Descendents of ConditionNode must implement the method evaluate"
    end
  end
  
  class ConjunctionConditionNode < ConditionNode
    def evaluate
      first_child.evaluate & second_child.evaluate
    end
  end
  
  class DisjunctionConditionNode < ConditionNode
    def evaluate
      first_child.evaluate | second_child.evaluate
    end
  end
end
