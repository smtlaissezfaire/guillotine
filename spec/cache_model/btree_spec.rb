require File.dirname(__FILE__) + "/../spec_helper"

module CachedModel
  describe ConditionNode do
    before :each do
      @node1 = mock 'node'
      @node2 = mock 'node'
    end
    
    it "should be able to init with 0 nodes" do
      node = ConditionNode.new
      node.children.should == []
    end
    
    it "should be empty if initialized with 0 nodes" do
      node = ConditionNode.new
      node.should be_empty
      node.should be_a_leaf
      node.is_a_leaf?.should be_true
    end
    
    it "should be able to init with 2 nodes" do
      node = ConditionNode.new(@node1, @node2)
      node.children.should == [@node1, @node2]
    end
    
    it "should not be empty if initialized with 2 nodes" do
      node = ConditionNode.new(@node1, @node2)
      node.should_not be_empty
      node.should_not be_a_leaf
      node.is_a_leaf?.should be_false
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
      describe "when both children are leafs" do
        before :each do
          @child_one = mock(ConditionNode, :empty? => true, :evaluate => nil)
          @child_two = mock(ConditionNode, :empty? => true, :evaluate => nil)
          @root = ConditionNode.new(@child_one, @child_two)
        end
        
        it "should return nil" do
          @root.evaluate.should be_nil
        end
      end
      
      describe "when the first child is empty" do
        before :each do
          @child_one = mock(ConditionNode, :empty? => true, :evaluate => nil)
          @child_two = mock(ConditionNode, :empty? => false, :evaluate => [:child_two_evaluation])
          @root = ConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the evaluation of the second child" do
          @root.evaluate.should == [:child_two_evaluation]
        end
      end
      
      describe "when the second child is empty" do
        before :each do
          @child_one = mock(ConditionNode, :empty? => false, :evaluate => [:child_one_evaluation])
          @child_two = mock(ConditionNode, :empty? => true, :evaluate => nil)
          @root = ConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the evaluation of the first child" do
          @root.evaluate.should == [:child_one_evaluation]
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
