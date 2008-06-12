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
    
    def two_or_zero_children?
      two_children? || zero_children?
    end
    
    def two_children?
      children.size == 2
    end
    
    alias_method :zero_children?, :leaf?
  end
  
  class ConditionNode < ProperBinaryTree
    
  end
end
