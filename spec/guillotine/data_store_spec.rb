require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe DataStore do
    describe "data" do
      before :each do
        DataStore.__clear_all_tables!
        @column = mock 'column', :primary_key? => false
      end
      
      it "should return an empty array of tables"do
        DataStore.table_names.should == []
      end
      
      describe "with one table" do
        before :each do
          DataStore.__clear_all_tables!
          DataStore.create_table(:tbl_one, :columns => [@column])
        end
        
        it "should have the table :tbl_one" do
          DataStore.table_names.should == [:tbl_one]
        end
        
        it "should have no data for tbl_one" do
          DataStore.table(:tbl_one).should == []
        end
        
        it "should have no data for tbl_one, when tbl_one is given as a string" do
          DataStore.table("tbl_one").should == []
        end
        
        it "should be able to access the table by a symbol, even if created with a string" do
          DataStore.create_table("my_table", :columns => [@column])
          DataStore.table(:my_table).should_not be_nil
        end
      end
      
      describe "clearing all tables" do
        it "should reset the tables to empty" do
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.__clear_all_tables!
          DataStore.table_names.should be_empty
        end
      end
      
      describe "inspect" do
        it "should return 'Singleton Guillotine::DataStore'" do
          Guillotine::DataStore.inspect.should == "Singleton Guillotine::DataStore"
        end
      end
      
      describe "drop_table" do
        before :each do
          DataStore.__clear_all_tables!
        end
        
        it "should remove the table" do
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.drop_table(:foo)
          DataStore.table_names.should be_empty
        end
        
        it "should not remove other tables" do
          DataStore.create_table(:bar, :columns => [@column])
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.drop_table(:foo)
          DataStore.table_names.should == [:bar]
        end
        
        it "should be able to use strings instead of symbols" do
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.drop_table("foo")
          DataStore.table_names.should == []
        end
        
        it "should raise an error if the table doesn't exist" do
          lambda { 
            DataStore.drop_table(:a_table_never_seen_before)
          }.should raise_error(DataStore::UnknownTable)
        end
        
        describe "with :if_exists => true" do
          it "should drop the table if it exists" do
            DataStore.create_table(:foo, :columns => [@column])
            DataStore.drop_table(:foo, :if_exists => true)
            DataStore.table_names.should == []
          end
          
          it "should do nothing if the table does not exist" do
            DataStore.drop_table(:foo, :if_exists => true)
            DataStore.table_names.should == []
          end
        end
      end
      
      describe "create_table" do
        it "should raise an error if the table is already there" do
          DataStore.create_table(:foo, :columns => [@column])
          lambda { 
            DataStore.create_table(:foo, :columns => [@column])
          }.should raise_error(DataStore::TableAlreadyExists)
        end
        
        describe "with :force => true" do
          it "should not do anything if the table is already there" do
            DataStore.create_table(:foo, :columns => [@column])
            DataStore.create_table(:foo, :columns => [@column], :force => true)
            DataStore.table_names.should == [:foo]
          end
          
          it "should create the table if the table does not exist" do
            DataStore.create_table(:foo, :columns => [@column], :force => true)
            DataStore.table_names.should == [:foo]
          end
          
          it "should instantiate a new Table" do
            DataStore::Table.should_receive(:new).with(:foo, hash_including({ }))
            DataStore.create_table(:foo, :columns => [@column], :force => true)
          end
          
          it "should instantiate a table with the correct name" do
            DataStore::Table.should_receive(:new).with(:bar, hash_including({ }))
            DataStore.create_table(:bar, :columns => [@column], :force => true)
          end
        end
        
        it "should downcase the tablename" do
          DataStore.create_table("FOO", :columns => [@column])
          DataStore.table_names.should == [:foo]
        end
      end
      
      describe "tables" do
        it "should be empty with no tables" do
          DataStore.tables.should == []
        end
        
        it "should have one element with one table" do
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.tables.size.should equal(1)
        end
        
        it "should have the first one as a kind_of?(Table)" do
          DataStore.create_table(:foo, :columns => [@column])
          DataStore.tables.first.should be_a_kind_of(DataStore::Table)
        end
        
        it "should use the correct table name" do
          DataStore.create_table(:bar, :columns => [@column])
          DataStore.tables.first.table_name.should equal(:bar)
        end
      end
      
      describe "truncate_all_tables" do
         it "should truncate a single table" do
          tbl = DataStore.create_table(:foo, :columns => [@column])
          tbl << { :key => :value }
          DataStore.truncate_all_tables!
          DataStore.table(:foo).should == []
        end
        
         it "should truncate a second table" do
          tbl1 = DataStore.create_table(:foo, :columns => [@column])
          tbl2 = DataStore.create_table(:bar, :columns => [@column])
          tbl1 << { :key => :value }
          tbl2 << { :key => :bar }
          DataStore.truncate_all_tables!
          DataStore.table(:foo).should == []
          DataStore.table(:bar).should == []
        end
        
        it "should call the table's truncate method" do
          tbl = DataStore.create_table(:foo, :columns => [@column])
          
          tbl.stub!(:truncate).and_return nil
          
          tbl.should_receive(:truncate).with(no_args)
          DataStore.truncate_all_tables!
        end
      end

      describe "dump and laoding" do
        # TODO: Fixme when Database is no longer a module.
        def new_database
          Class.new do
            include Guillotine::DataStore::Database
          end.new
        end

        before(:each) do
          @data = {:foo => [{:bar => 17}, {:bar => 18}]}
          @database = new_database
          @marshal_data = Marshal.dump(@data)
        end

        describe "load" do
          it "should load the marshal dump" do
            @database.load(@marshal_data)
            @database.data.should == @data
          end
        end

        describe "dump" do
          it "should load the marshal dump" do
            @database.stub!(:data).and_return @data
            @database.dump.should == @marshal_data
          end
        end
      end
    end
  end
end
