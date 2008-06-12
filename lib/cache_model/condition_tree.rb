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
    def call
      raise NotImplementedError, "Descendents of ConditionNode must implement the method call"
    end
  end
  
  class ConjunctionConditionNode < ConditionNode
    def call
      first_child.call & second_child.call
    end
  end
  
  class DisjunctionConditionNode < ConditionNode
    def call
      first_child.call | second_child.call
    end
  end
end
