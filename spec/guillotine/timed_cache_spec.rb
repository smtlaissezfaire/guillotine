require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe TimedCache do
    before :each do
      @block = lambda { }
      @cache = TimedCache.new({ }, @block)
      @mysql_adapter = mock 'mysql adapter class', :define_method => nil
      @mysql_adapter.stub!(:class_eval)
      @row_selector = mock(::Guillotine::ActiveRecord::RowSelector, :select => [])
    end
    
    describe "mysql adapter" do
      it "should have the proper class for the mysql adapter" do
        @cache.mysql_adapter.should equal(::ActiveRecord::ConnectionAdapters::MysqlAdapter)
      end
      
      it "should be able to set the class for the mysql adapter" do
        @cache.mysql_adapter = @mysql_adapter
        @cache.mysql_adapter.should equal(@mysql_adapter)
      end
      
      it "should be able to reset the mysql adapter to it's default" do
        @cache.mysql_adapter = @mysql_adapter
        @cache.reset_mysql_adapter!
        @cache.mysql_adapter.should == ::ActiveRecord::ConnectionAdapters::MysqlAdapter
      end
      
      it "should have the default row selector as a ::Guillotine::ActiveRecord::RowSelector" do
        @cache.row_selector.should be_a_kind_of(::Guillotine::ActiveRecord::RowSelector)
      end
      
      it "should be able to set the default row selector" do
        @cache.row_selector = @row_selector
        @cache.row_selector.should equal(@row_selector)
      end
    end
    
    describe "cache" do
      before :each do
        @cache.row_selector = @row_selector
        @mysql_adapter = Class.new do
          def select
          end
        end
        @cache.mysql_adapter = @mysql_adapter
      end
      
      it "should call the block" do
        @block.should_receive(:call).with(no_args)
        @cache.cache
      end
      
      def cache(&blk)
        @cache.block = blk
        @cache.cache
      end
      
      it "should alias the method select to __guillotine_select__" do
        old_select = @mysql_adapter.instance_method(:select)
        cache { 
          @mysql_adapter.instance_method(:__guillotine_select__).should == old_select
        }
      end
      
      it "should overwrite the select method with a call to the guillotine row selector" do
        pending 'todo'
        @cache.reset_mysql_adapter!
        
        sql, name = "SELECT * FROM users", "User Load"
        @row_selector.should_receive(:select).with(sql, name).and_return []
        cache do
          User.find_by_sql("SELECT * FROM users")
        end
      end
      
      it "should rescue from an error and call the __guillotine_select__ method with the sql and name"
      
      it "should be able to call the select method without a name"
      
      it "should return the select method to it's old state" do
        old_select = @mysql_adapter.instance_method(:select)
        cache { }
        @mysql_adapter.instance_method(:select).should == old_select
      end
      
      it "should return the method to it's old state, even when an an error occurs (it should use the ensure keyword)" do
        old_select = @mysql_adapter.instance_method(:select)
        begin; cache { raise }; rescue; nil; end
        @mysql_adapter.instance_method(:select).should == old_select
      end
      
      it "should remove the method __guillotine_select__ (it should not leave any dangling methods)" do
        old_select = @mysql_adapter.instance_methods(false)
        cache { }
        @mysql_adapter.instance_methods(false).should == old_select
      end
    end
  end
end
