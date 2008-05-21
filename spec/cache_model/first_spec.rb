require File.dirname(__FILE__) + "/../spec_helper"

module CacheModel
  describe "finding an element with :first" do
    before :each do
      @target = Person
      @finder = CachedModel.new(@target)
      @scott = Person.create!(:first_name => "Scott", :last_name => "Taylor")
      @matt = Person.create!(:first_name => "Matt", :last_name => "Pelletier")
    end
    
    after :each do
      Person.delete_all
    end
    
    describe "with an equal condition" do
      it "should parse it as a hash for the name scott" do
        @finder.find(:first, :conditions => { :first_name => "Scott" }).should == @scott
      end
      
      it "should parse it as a hash for the name Matt" do
        @finder.find(:first, :conditions => { :first_name => "Matt" }).should == @matt
      end
      
      it "should parse it as a hash for the last name Taylor" do
        @finder.find(:first, :conditions => { :last_name => "Taylor" }).should == @scott
      end
      
      it "should parse it as a hash for the last name Pelletier" do
        @finder.find(:first, :conditions => { :last_name => "Pelletier" }).should == @matt
      end
      
      it "should parse it as an array with the first name of 'Scott'" do
        @finder.find(:first, :conditions => ["first_name = ?", "Scott"]).should == @scott
      end
      
      it "should parse it as an array with the first name of 'Matt'" do
        @finder.find(:first, :conditions => ["first_name = ?", "Matt"]).should == @matt
      end
      
      it "should parse it as an array with the last name of 'Taylor'" do
        @finder.find(:first, :conditions => ["last_name = ?", "Taylor"]).should == @scott
      end
      
      it "should find it from the cache" do
        @finder.find(:first)
        @target.should_not_receive(:find).with(:first)
        @finder.find(:first, :conditions => { :first_name => "Scott"})
      end
    end
    
    describe "with a != condition" do
      describe "with an array" do
        it "should find scott when give not matt" do
          @finder.find(:first, :conditions => ["first_name != ?", "Matt"]).should == @scott
        end
        
        it "should find matt when given scott" do
          @finder.find(:first, :conditions => ["first_name != ?", "Scott"]).should == @matt
        end
      end
    end
  end
end
