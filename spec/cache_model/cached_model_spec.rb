require File.dirname(__FILE__) + "/../spec_helper"

describe ActiveRecord::Base do
  it "should have the cache_model class method" do
    ActiveRecord::Base.should respond_to(:cache_model)
  end
end

module CacheModel
  describe CachedModel do
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
    
    it "should find all the records even when passed find(:first)" do
      @target.stub!(:find)
      @target.should_receive(:find).with(:all)
      @finder.find(:first)
    end
    
    describe "with an id in the cache" do
      before :each do
        @finder.find(:all)
      end
      
      it "should grab the record out of the cache" do
        @finder.find(@person.id).should == @person
      end
    end
    
    describe "finding an element with :first and no params" do
      it "should find the first record" do
        @finder.find(:first).should == @person
      end
    end
    
    describe "finding an element with :first and an :include" do
      it "should pass the argumetns onto the regular find" do
        @target.should_receive(:find).with(:first, :include => :foo)
        @finder.find(:first, :include => :foo)
      end
    end
   
    describe "finding an element with :all and an :include" do
      it "should pass the argumetns onto the regular find" do
        @target.should_receive(:find).with(:all, :include => :foo)
        @finder.find(:all, :include => :foo)
      end
    end
  end
  
  describe CachedModel do
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

        end
      end
    end
  end
end
