require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module DataStore
    describe Schema do
      before(:each) do
        @table = mock 'table'
        @schema = Schema.new
        @col1 = mock 'column'
      end

      it "should belong to a table" do
        @schema.table = @table
        @schema.table.should equal(@table)
      end

      it "should be able to set a list of columns" do
        @schema.columns = [@col1]
        @schema.columns.should == [@col1]
      end

      it "should have an empty list of columns after init'ing" do
        @schema.columns.should == []
      end

      describe "a table with no primary keys", :shared => true do
        it "should have a nil primary key" do
          @schema.primary_key.should be_nil
        end

        it "should not have a primary key" do
          @schema.primary_key?.should be_false
        end
      end

      describe "primary key" do
        describe "with no columns" do
          it_should_behave_like "a table with no primary keys"
        end

        describe "with a list of columns with no primary key" do
          before(:each) do
            @col1.stub!(:primary_key?).and_return false
            @schema.columns = [@col1]
          end

          it_should_behave_like "a table with no primary keys"
        end

        describe "with a list of columns with a primary key" do
          before(:each) do
            @col1.stub!(:primary_key?).and_return true
            @col1.stub!(:column_name).and_return "foo"
            @schema.columns = [@col1]
          end

          it "should return the primary key" do
            @schema.primary_key.should == @col1
          end

          it "should have a primary_key?" do
            @schema.primary_key?.should be_true
          end
        end
      end

      describe "auto_incrementing?" do
        it "should be false if there is no primary key" do
          @schema.columns = []
          @schema.auto_incrementing?.should be_false
        end

        describe "when there is a primary key" do
          before(:each) do
            @column = mock 'column', :primary_key? => true
            @schema.columns = [@column]
          end

          it "should be true if the column is auto-incrementing" do
            @column.stub!(:auto_incrementing?).and_return true
            @schema.auto_incrementing?.should be_true
          end

          it "should be false if the primary key column isn't auto-incrementing" do
            @column.stub!(:auto_incrementing?).and_return false
            @schema.auto_incrementing?.should be_false
          end
        end
      end
    end
  end
end
