require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe DataStore do
    describe "data" do
      before :each do
        DataStore.__clear_all_tables!
      end
      
      it "should return an empty array of tables"do
        DataStore.tables.should == []
      end
      
      describe "with one table" do
        before :each do
          DataStore.__clear_all_tables!
          DataStore.add_table(:tbl_one)
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
          DataStore.add_table("my_table")
          DataStore.table(:my_table).should_not be_nil
        end
      end
      
      describe "clearing all tables" do
        it "should reset the tables to empty" do
          DataStore.add_table(:foo)
          DataStore.__clear_all_tables!
          DataStore.tables.should be_empty
        end
      end
      
      describe "inspect" do
        it "should return 'Singleton Guillotine::DataStore'" do
          Guillotine::DataStore.inspect.should == "Singleton Guillotine::DataStore"
        end
      end
    end
  end
end
