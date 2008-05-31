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
    
    describe "with one attribute" do
      describe "with an equal condition" do
        describe "with a hash" do
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
        end
        
        describe "with an array" do
          it "should parse it as an array with the first name of 'Scott'" do
            @finder.find(:first, :conditions => ["first_name = ?", "Scott"]).should == @scott
          end
          
          it "should parse it as an array with the first name of 'Matt'" do
            @finder.find(:first, :conditions => ["first_name = ?", "Matt"]).should == @matt
          end
          
          it "should parse it as an array with the last name of 'Taylor'" do
            @finder.find(:first, :conditions => ["last_name = ?", "Taylor"]).should == @scott
          end
          
          it "should find none of the records if it does not match" do
            @finder.find(:first, :conditions => ["first_name = ?", "John"]).should be_nil
          end
        end
        
        it "should find it from the cache" do
          @finder.find(:first)
          @target.should_not_receive(:find).with(:first)
          @finder.find(:first, :conditions => { :first_name => "Scott"})
        end
      end
      
      describe "with a != condition" do
        it "should find scott when give not matt" do
          @finder.find(:first, :conditions => ["first_name != ?", "Matt"]).should == @scott
        end
        
        it "should find matt when given scott" do
          @finder.find(:first, :conditions => ["first_name != ?", "Scott"]).should == @matt
        end
      end
    end
    
    describe "with two attributes" do
      describe "with two equalities" do
        describe "with a hash" do
          it "should find the user Scott Taylor" do
            conditions = { :first_name => "Scott", :last_name => "Taylor" }
            @finder.find(:first, :conditions => conditions).should == @scott
          end
          
          it "should find the user Matt Pelletier" do
            conditions = {"first_name" => "Matt", "last_name" => "Pelletier"}
            @finder.find(:first, :conditions => conditions).should == @matt
          end
          
          it "should not find the user Matt Taylor" do
            conditions = {"first_name" => "Matt", "last_name" => "Taylor"}
            @finder.find(:first, :conditions => conditions).should be_nil
          end
        end
        
        describe "with an array" do
          it "should find the user Scott Taylor" do
            conditions = ["first_name = ? AND last_name = ?", "Scott", "Taylor"]
            @finder.find(:first, :conditions => conditions).should == @scott
          end
          
          it "should find the user Matt Pelletier" do
            conditions = ["first_name = ? AND last_name = ?", "Matt", "Pelletier"]
            @finder.find(:first, :conditions => conditions).should == @matt
          end
          
          it "should not find the user Matt Taylor" do
            pending 'todo'
            conditions = ["first_name = ? AND last_name = ?", "Matt", "Taylor"]
            @finder.find(:first, :conditions => conditions).should be_nil
          end
        end
      end
      
      describe "with two inequalities" do
        
      end
      
      describe "with an inequality and an equality" do
        
      end
    end
  end
end

