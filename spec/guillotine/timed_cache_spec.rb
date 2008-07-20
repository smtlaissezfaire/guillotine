require File.dirname(__FILE__) + "/../spec_helper"

module Guillotine
  describe TimedCache do
    before :each do
      @block = lambda { }
      @cache = TimedCache.new({ }, @block)
      @mysql_adapter = mock 'mysql adapter class', :alias_method => nil, :define_method => false
      @row_selector = ::Guillotine::ActiveRecord::RowSelector.new
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
      
      it "should alias the method select_rows to __guillotine_select_rows__" do
        @mysql_adapter.should_receive(:alias_method).with(:__guillotine_select_rows__, :select_rows)
        cache { }
      end
      
      it "should overwrite the select_rows method with a call to the guillotine row selector" do
        @cache.reset_mysql_adapter!
        @cache.row_selector = @row_selector
        
        sql, name = "SELECT * FROM users", "User Load"
        @row_selector.should_receive(:select).with(sql, name).and_return []
        cache do
          User.find_by_sql("SELECT * FROM users")
        end
      end
    end
  end
end
