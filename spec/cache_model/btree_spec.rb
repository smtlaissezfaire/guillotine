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
          @child_one = mock(ConditionNode, :empty? => false, :call => nil)
          @child_two = mock(ConditionNode, :empty? => false, :call => nil)
          @root = ConditionNode.new(@child_one, @child_two)
        end
        
        it "should raise an error" do
          lambda { 
            @root.call
          }.should raise_error(NotImplementedError, "Descendents of ConditionNode must implement the method call")
        end
      end
    end
    
    describe ConjunctionConditionNode do
      describe "when both children are not leafs" do
        before :each do
          @child_one = mock(ConjunctionConditionNode, :empty? => false, :call => [:one, :two])
          @child_two = mock(ConjunctionConditionNode, :empty? => false, :call => [:two])
          @root = ConjunctionConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the intersection (with &) of evaluating the two children" do
          @root.call.should == [:two]
        end
        
        it "should return an empty array when there is no intersection (with different evaluations)" do
          @child_one.stub!(:call).and_return [:one, :three]
          @root.call.should == []
        end
        
        it "should call the first child with the collection" do
          @child_one.should_receive(:call).with([:a, :collection])
          @root.call([:a, :collection])
        end
        
        it "should call the second child with the collection" do
          @child_two.should_receive(:call).with([:a, :collection]).and_return []
          @root.call([:a, :collection])
        end

      end
    end
    
    describe DisjunctionConditionNode do
      describe "when both children are not leafs" do
        before :each do
          @child_one = mock(DisjunctionConditionNode, :empty? => false, :call => [:one, :two])
          @child_two = mock(DisjunctionConditionNode, :empty? => false, :call => [:three])
          @root = DisjunctionConditionNode.new(@child_one, @child_two)
        end
        
        it "should return the union (with Array#|) of evaluating the two children" do
          @root.call.should == [:one, :two, :three]
        end
        
        it "should return the union, removing duplicates  (with different evaluations)" do
          @child_one.stub!(:call).and_return [:one, :three]
          @root.call.should == [:one, :three]
        end
        
        it "should call the first child with the collection" do
          @child_one.should_receive(:call).with([:a, :collection])
          @root.call([:a, :collection])
        end
        
        it "should call the second child with the collection" do
          @child_two.should_receive(:call).with([:a, :collection]).and_return []
          @root.call([:a, :collection])
        end
      end
    end
  end
end
