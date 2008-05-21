require File.dirname(__FILE__) + "/../spec_helper"

module CacheModel
  describe "find :all" do
    before :each do
      @target = Person
      @finder = CachedModel.new(@target)
      @person = Person.create!
    end
    
    after :each do
      begin
        Person.destroy_all
      rescue
        nil
      end
    end
    
    it "should find all records" do
      @finder.find(:all).should == [@person]
    end
    
    it "should only find the records once" do
      @target.should_receive(:find).with(:all).once

      @finder.find(:all)
      @finder.find(:all)
    end
  end
end
