require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
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
    
    describe ConjunctionConditionNode do
      before :each do
        @child_one = mock(ConjunctionConditionNode, :empty? => false, :call => [:one, :two])
        @child_two = mock(ConjunctionConditionNode, :empty? => false, :call => [:two])
        @root = ConjunctionConditionNode.new(@child_one, @child_two)
      end
      
      it "should return the intersection (with &) of evaluating the two children" do
        @root.call([:one, :two, :three, :four]).should == [:two]
      end
      
      it "should return an empty array when there is no intersection (with different evaluations)" do
        @child_one.stub!(:call).and_return [:one, :three]
        @root.call([:one, :two, :three, :four]).should == []
      end
      
      it "should call the first child with the collection" do
        @child_one.should_receive(:call).with([:a, :collection])
        @root.call([:a, :collection])
      end
      
      it "should call the second child with the *resulting collection* from the first call" do
        @child_one.should_receive(:call).with([:one, :two]).and_return [:two]
        @child_two.should_receive(:call).with([:two]).and_return [:two]
        @root.call([:one, :two])
      end
      
      it "should not be equal to a DisjunctionConditionNode, even if the two have the same children" do
        disjunction_condition_node = DisjunctionConditionNode.new(*@root.children)
        @root.should_not eql(disjunction_condition_node)
      end
      
      it "should be empty when given an empty array" do
        @root.call([]).should eql([])
      end
    end
    
    describe DisjunctionConditionNode do
      before :each do
        @child_one = mock(DisjunctionConditionNode, :empty? => false, :call => [:one, :two])
        @child_two = mock(DisjunctionConditionNode, :empty? => false, :call => [:three])
        @root = DisjunctionConditionNode.new(@child_one, @child_two)
      end
      
      it "should return the union (with Array#|) of evaluating the two children" do
        @root.call([:one, :two, :three]).should == [:one, :two, :three]
      end
      
      it "should return the union, removing duplicates  (with different evaluations)" do
        @child_one.stub!(:call).and_return [:one, :three]
        @root.call([:one, :two, :three]).should == [:one, :three]
      end
      
      it "should call the first child with the collection" do
        @child_one.should_receive(:call).with([:a, :collection])
        @root.call([:a, :collection])
      end
      
      it "should call the second child with the results of the first call" do
        @child_one.stub!(:call).and_return [:parts_of_a_collection]
        @child_two.should_receive(:call).with([:a, :collection]).and_return []
        @root.call([:a, :collection])
      end
      
      it "should be empty when given an empty array" do
        @root.call([]).should eql([])
      end
    end
  end
end
