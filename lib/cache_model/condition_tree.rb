module CachedModel
  class ProperBinaryTree
    def initialize(child_one, child_two)
      @children = [child_one, child_two]
    end
    
    attr_reader :children
    
    def eql?(other)
      other.children == self.children
    end
    
    alias_method :==, :eql?
    
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
    def call(*args)
      raise NotImplementedError, "Descendents of ConditionNode must implement the method call"
    end
  end
  
  class ConjunctionConditionNode < ConditionNode
    # If we can a-priori figure out whether call one or call two 
    # returns less records, we'll be building a real in-memory database!
    def call(*args)
      results_of_first_call = first_child.call(*args)
      results_of_first_call & second_child.call(results_of_first_call)
    end
  end
  
  class DisjunctionConditionNode < ConditionNode
    def call(*args)
      first_child.call(*args) | second_child.call(*args)
    end
  end
end
