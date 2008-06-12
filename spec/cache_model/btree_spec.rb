require File.dirname(__FILE__) + "/../spec_helper"

module CachedModel
  describe ConditionNode do
    before :each do
      @node1 = mock 'node'
      @node2 = mock 'node'
    end
    
    it "should be able to init with 2 nodes" do
      node = ConditionNode.new(@node1, @node2)
      node.children.should == [@node1, @node2]
    end
    
    it "should raise an error if initialized with 1 argument" do
      lambda { 
        ConditionNode.new(@node1)
      }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if initialized with 3 arguments" do
      lambda { 
        ConditionNode.new(@node1, @node2, mock('a mock'))
      }.should raise_error(ArgumentError)
    end
    
    describe "evaluation" do
      describe "when both children are parents" do
        before :each do
          @child_one = mock(ConditionNode, :empty? => false, :evaluate => nil)
          @child_two = mock(ConditionNode, :empty? => false, :evaluate => nil)
          @root = ConditionNode.new(@child_one, @child_two)
        end
        
        it "should raise an error" do
          lambda { 
            @root.evaluate
          }.should raise_error(NotImplementedError, "Descendents of ConditionNode must implement the method evaluate")
        end
      end
    end
    
    describe ConjunctionConditionNode do
      describe "when both children are not leafs" do
        before :each do
          @child_one = mock(ConjunctionConditionNode, :empty? => false, :evaluate => [:one, :two])
          @child_two = mock(ConjunctionConditionNode, :empty? => false, :evaluate => [:two])
          @root = ConjunctionConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the intersection (with &) of evaluating the two children" do
          @root.evaluate.should == [:two]
        end
        
        it "should return an empty array when there is no intersection (with different evaluations)" do
          @child_one.stub!(:evaluate).and_return [:one, :three]
          @root.evaluate.should == []
        end
      end
    end
    
    describe DisjunctionConditionNode do
      describe "when both children are not leafs" do
        before :each do
          @child_one = mock(DisjunctionConditionNode, :empty? => false, :evaluate => [:one, :two])
          @child_two = mock(DisjunctionConditionNode, :empty? => false, :evaluate => [:three])
          @root = DisjunctionConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the union (with Array#|) of evaluating the two children" do
          @root.evaluate.should == [:one, :two, :three]
        end
        
        it "should return the union, removing duplicates  (with different evaluations)" do
          @child_one.stub!(:evaluate).and_return [:one, :three]
          @root.evaluate.should == [:one, :three]
        end
      end
    end


  end
end
