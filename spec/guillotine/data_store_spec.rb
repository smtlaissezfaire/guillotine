require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe DataStore do
    describe "data" do
      it "should return an empty array of tables"do
        DataStore.tables.should == []
      end
      
      describe "with one table" do
        before :each do
          DataStore.create_table(:tbl_one)
        end
        
        it "should have the table :tbl_one" do
          DataStore.tables.should == [:tbl_one]
        end
        
        it "should have no data for tbl_one" do
          DataStore.table(:tbl_one).should == []
        end
        
        it "should have no data for tbl_one, when tbl_one is given as a string" do
          DataStore.table("tbl_one").should == []
        end
        
        it "should be able to access the table by a symbol, even if created with a string" do
          DataStore.create_table("my_table")
          DataStore.table(:my_table).should_not be_nil
        end
      end
      
      describe "clearing all tables" do
        it "should reset the tables to empty" do
          DataStore.create_table(:foo)
          DataStore.__clear_all_tables!
          DataStore.tables.should be_empty
        end
      end
      
      describe "inspect" do
        it "should return 'Singleton Guillotine::DataStore'" do
          Guillotine::DataStore.inspect.should == "Singleton Guillotine::DataStore"
        end
      end
      
      describe "drop_table" do
        it "should remove the table" do
          DataStore.create_table(:foo)
          DataStore.drop_table(:foo)
          DataStore.tables.should be_empty
        end
        
        it "should not remove other tables" do
          DataStore.create_table(:bar)
          DataStore.create_table(:foo)
          DataStore.drop_table(:foo)
          DataStore.tables.should == [:bar]
        end
        
        it "should be able to use strings instead of symbols" do
          DataStore.create_table(:foo)
          DataStore.drop_table("foo")
          DataStore.tables.should == []
        end
        
        it "should raise an error if the table doesn't exist" do
          lambda { 
            DataStore.drop_table(:a_table_never_seen_before)
          }.should raise_error(DataStore::UnknownTable)
        end
        
        describe "with :if_exists => true" do
          it "should drop the table if it exists" do
            DataStore.create_table(:foo)
            DataStore.drop_table(:foo, :if_exists => true)
            DataStore.tables.should == []
          end
          
          it "should do nothing if the table does not exist" do
            DataStore.drop_table(:foo, :if_exists => true)
            DataStore.tables.should == []
          end
        end
      end
      
      describe "create_table" do
        it "should raise an error if the table is already there" do
          DataStore.create_table(:foo)
          lambda { 
            DataStore.create_table(:foo)
          }.should raise_error(DataStore::TableAlreadyExists)
        end
        
        describe "with :if_exists => true" do
          it "should not do anything if the table is already there" do
            DataStore.create_table(:foo)
            DataStore.create_table(:foo, :if_exists => true)
            DataStore.tables.should == [:foo]
          end
          
          it "should create the table if the table does not exist" do
            DataStore.create_table(:foo, :if_exists => true)
            DataStore.tables.should == [:foo]
          end
        end
      end
      
      describe "initial_insert" do
        it "should take a table name and an array" do
          lambda { 
            DataStore.initial_insert(:a_table_name, [])
          }.should_not raise_error
        end
        
        it "should store the data in the table" do
          DataStore.create_table(:a_table)
          DataStore.initial_insert(:a_table, [{ :foo => :bar }])
          DataStore.table(:a_table).should == [{ :foo => :bar }]
        end
        
        xit "TODO: check for synchronization issues.  #{__FILE__}:#{__LINE__}"
      end
    end
  end
end
