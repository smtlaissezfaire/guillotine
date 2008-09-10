require File.dirname(__FILE__) + "/../../spec_helper"

module Guillotine
  module Expressions
    describe GroupBy do
      before :each do
        @column_one = mock 'column'
        @column_two = mock 'column'
      end
      
      it "should have a column, if given one" do
        GroupBy.new(@column_one).column.should == @column_one
      end
      
      it "should have multiple columns, if initialized with them" do
        GroupBy.new(@column_one, @column_two).columns.should == [@column_one, @column_two]
      end
      
      it "should return all the columns if #column is called, and multiple columns where given in the constructor" do
        GroupBy.new(@column_one, @column_two).column.should == [@column_one, @column_two]
      end
      
      describe "==" do
        it "should be true if the other expression has the same (==) elements (in the same order)" do
          one = GroupBy.new(@column_one, @column_two)
          two = GroupBy.new(@column_one, @column_two)
          one.should == two
          two.should == one
        end
        
        it "should be false if the other has the same elements, in a different order" do
          one = GroupBy.new(@column_two, @column_one)
          two = GroupBy.new(@column_one, @column_two)
          one.should_not == two
          two.should_not == one
        end
      end
      
      describe "grouping" do
        before :each do
          @column_one.stub!(:name).and_return :foo
          @column_three = mock 'column three'
        end
        
        describe "grouping an empty collection" do
          it "should return the collection" do
            GroupBy.new(@column_one).call([]).should == []
          end
          
          it "should return the collection if it's empty (using any sort of collection - duck type it)" do
            a_collection = mock 'a collection'
            a_collection.stub!(:empty?).and_return true
            GroupBy.new(@column_one).call(a_collection).should == a_collection
          end
        end
        
        describe "grouping on a collection, with only one item" do
          it "should return the record" do
            @column_one.stub!(:name).and_return :foo
            GroupBy.new(@column_one).call([{ :foo => :bar }]).should == [{ :foo => :bar }]
          end
        end
        
        describe "grouping on a collection on one row" do
          it "should return the records when the data is not unique" do
            records = [
             { :foo => :bar },
             { :foo => :quxx }
            ]
            @column_one.stub!(:name).and_return :foo
            GroupBy.new(@column_one).call(records).should == records
          end
          
          it "should return a record that column it's grouping on" do
            records = [
             { :foo => :bar },
             { :foo => :bar }
            ]
            @column_one.stub!(:name).and_return(:foo)
            GroupBy.new(@column_one).call(records).should == [{ :foo => :bar }]
          end
          
          it "should return the first record it finds" do
            records = [
             { :foo => :bar, :baz => :quxx },
             { :foo => :bar, :baz => :fnord }
            ]
            @column_one.stub!(:name).and_return(:foo)
            GroupBy.new(@column_one).call(records).should == [{ :foo => :bar, :baz => :quxx }]
          end
          
          it "should only group rows which are the same" do
            records = [
             { :foo => :bar },
             { :foo => :bar },
             { :foo => :quxx }
            ]
            @column_one.stub!(:name).and_return(:foo)
            GroupBy.new(@column_one).call(records).should == [{ :foo => :bar }, { :foo => :quxx }]
          end
          
          it "should work for a different row" do
            records = [
             { :bar => :bar },
             { :bar => :bar },
             { :bar => :quxx }
            ]
            @column_one.stub!(:name).and_return(:bar)
            GroupBy.new(@column_one).call(records).should == [{ :bar => :bar }, { :bar => :quxx }]
          end
        end
        
        describe "grouping by two rows" do
          it "should group by one row, if only one row has the same values" do
            records = [
             { :foo => :bar,  :bar => :bar },
             { :foo => :bar,  :bar => :quxx }
            ]
            @column_one.stub!(:name).and_return(:foo)
            @column_two.stub!(:name).and_return(:bar)
            group = GroupBy.new(@column_one, @column_two)
            group.call(records).should == [{ :foo => :bar, :bar => :bar}]
          end
          
          it "should group by one row, if only one row has the same values, and it's the second row" do
            records = [
             { :foo => :baz,  :bar => :quxx },
             { :foo => :bar,  :bar => :quxx }
            ]
            @column_one.stub!(:name).and_return(:foo)
            @column_two.stub!(:name).and_return(:bar)
            group = GroupBy.new(@column_one, @column_two)
            group.call(records).should == [{ :foo => :baz, :bar => :quxx}]
          end
          
          it "should return both rows, if neither are unique" do
            records = [
             { :foo => :baz,  :bar => :fnord },
             { :foo => :bar,  :bar => :quxx }
            ]
            @column_one.stub!(:name).and_return(:foo)
            @column_two.stub!(:name).and_return(:bar)
            group = GroupBy.new(@column_one, @column_two)
            group.call(records).should == records
          end
          
          it "should group by 3 columns" do
            records = [
             first_record =  { :foo => :baz,   :bar => :fnord , :quxx => :fnord  },
             second_record = { :foo => :bar,   :bar => :quxx,   :quxx => :fnord },
             third_record =  { :foo => :fnord, :bar => :baz,    :quxx => :baz   }
            ]
            @column_one.stub!(:name).and_return(:foo)
            @column_two.stub!(:name).and_return(:bar)
            @column_three.stub!(:name).and_return(:quxx)
            group = GroupBy.new(@column_one, @column_two, @column_three)
            group.call(records).should == [first_record, third_record]
          end
        end
      end
      
      describe "to_sql" do
        it "should be GROUP BY a single column" do
          @column_one.stub!(:to_sql).and_return "foo.bar"
          GroupBy.new(@column_one).to_sql.should == "GROUP BY foo.bar"
        end
        
        it "should GROUP BY two columns" do
          @column_one.stub!(:to_sql).and_return "foo.bar"
          @column_two.stub!(:to_sql).and_return "baz.quxx"
          GroupBy.new(@column_one, @column_two).to_sql.should == "GROUP BY foo.bar, baz.quxx"
        end
      end
    end
  end
end

  
