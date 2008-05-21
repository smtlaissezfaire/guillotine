require File.dirname(__FILE__) + "/../spec_helper"

module CacheModel
  describe "finding by id" do
    before :each do
      @target = Person
      @finder = CachedModel.new(@target)
    end
    
    describe "with an id in the cache" do
      before :each do
        @person = Person.create!
      end
      
      after :each do
        begin
          Person.destroy_all
        rescue
          nil
        end
      end

      before :each do
        @finder.find(:all)
      end
      
      it "should grab the record out of the cache" do
        @finder.find(@person.id).should == @person
      end
      
      it "should grab the record even if it is given the id as a string" do
        @finder.find(@person.id.to_s).should == @person
      end
    end
    
    describe "when there are no records, and nothing in the cache" do
      it "should return nil when asking for 1" do
        @finder.find(1).should be_nil
      end
      
      it "should return nil when asking for 2" do
        @finder.find(2).should be_nil
      end

      it "should be nil when asking for the string 1" do
        @finder.find("1").should be_nil
      end
      
      it "should be nil when asking for the string 2" do
        @finder.find("2").should be_nil
      end
    end
    
    describe "when there are no records" do
      
    end
  end
end
