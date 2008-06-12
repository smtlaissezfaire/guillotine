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
  end
end
