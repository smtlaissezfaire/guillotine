require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe TimedCache do
    before :each do
      @block = lambda { }
      @cache = TimedCache.new({ }, @block)
      @mysql_adapter = mock 'mysql adapter class'
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
      
      it "should alias the method select to __old_select_aliased_by_guillotine__" do
        old_select = @mysql_adapter.instance_method(:select)
        cache { 
          @mysql_adapter.instance_method(:__old_select_aliased_by_guillotine__).should == old_select
        }
      end
      
      it "should overwrite the select method with a call to the guillotine row selector" do
        @cache.reset_mysql_adapter!
        
        sql = "SELECT * FROM users"
        @row_selector.should_receive(:select).with(sql).and_return []
        cache do
          User.find_by_sql("SELECT * FROM users")
        end
      end
      
      it "should rescue from an error and call the __old_select_aliased_by_guillotine__ method with the sql and name" do
        @cache.reset_mysql_adapter!
        
        sql, name = "SELECT * FROM users", "User Load"
        @row_selector.stub!(:select).and_raise(Exception)
        
        connection = User.connection
        connection.should_receive(:__old_select_aliased_by_guillotine__).with(sql, name).and_return []
        
        cache do
          User.find_by_sql("SELECT * FROM users")
        end
      end
      
      it "should log to the guillotine log when it's a cache hit"
      
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
      
      it "should remove the method __old_select_aliased_by_guillotine__ (it should not leave any dangling methods)" do
        old_select = @mysql_adapter.instance_methods(false)
        cache { }
        @mysql_adapter.instance_methods(false).should == old_select
      end
    end
  end
  
  describe "class method cache" do
    before :each do
      @timed_cache = mock(TimedCache, :cache => nil)
      TimedCache.stub!(:new).and_return @timed_cache
      
      @a_hash = { }
      @a_lambda = lambda { }
    end
    
    it "should create a new timed cache with the params" do
      TimedCache.should_receive(:new).with(@a_hash, @a_lambda).and_return @timed_cache
      TimedCache.cache(@a_hash, @a_lambda)
    end
    
    it "should call the cache method" do
      @timed_cache.should_receive(:cache).with(no_args)
      TimedCache.cache(@a_hash, @a_lambda)
    end
  end
end
