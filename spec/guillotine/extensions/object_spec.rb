require File.dirname(__FILE__) + "/../../spec_helper"

describe Object do
  describe "size" do
    before :each do
      @object = Object.new
      @string = "foo bar baz"
      @unmarshable_object = Class.new { }
    end
    
    it "should have the method object_size" do
      @object.should respond_to(:object_size)
    end
    
    it "should return the size of the marshaled string" do
      @object.object_size.should == Marshal.dump(@object).size
    end
    
    it "should return the size of a different object" do
      @string.object_size.should == Marshal.dump(@string).size
    end
    
    it "should return nil if the size cannot be calculated with Marshal" do
      @unmarshable_object.object_size.should be_nil
    end
  end
  
  describe "guillotine_cache" do
    before :each do
      @object = Object.new
      @timed_cache = mock(Guillotine::TimedCache)
    end
    
    it "should raise an error if no block is given" do
      lambda { 
        @object.guillotine_cache
      }.should raise_error(LocalJumpError, "no block given")
    end
    
    it "should forward a request to a Guillotine::TimedCache with the params" do
      blk = lambda { }
      hash = { :ttl => 300 }
      
      Guillotine::TimedCache.should_receive(:new).with(hash, blk).and_return @timed_cache
      @object.guillotine_cache(hash, &blk)
    end
        
    it "should forward a request to a Guillotine::TimedCache with an empty hash when none is given" do
      blk = lambda { }
      Guillotine::TimedCache.should_receive(:new).with({ }, blk).and_return @timed_cache
      @object.guillotine_cache(&blk)
    end

    it "should raise an error if active record is not around" 
  end
end
