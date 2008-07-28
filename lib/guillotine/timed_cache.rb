module Guillotine
  class TimedCache
    def self.cache(hash, block)
      new(hash, block).cache
    end
    
    # TODO: use the hash for ttl.  Check options
    def initialize(hash, block)
      @block = block
    end
    
    attr_accessor :block
    
    def cache
      swap { @block.call }
    end
    
    def mysql_adapter
      @mysql_adapter ||= ::ActiveRecord::ConnectionAdapters::MysqlAdapter
    end
    
    def reset_mysql_adapter!
      @mysql_adapter = nil
    end
    
    attr_writer :mysql_adapter
    
    def row_selector
      @row_selector ||= ::Guillotine::ActiveRecord::RowSelector.new
    end
    
    attr_writer :row_selector
    
  private
    
    def swap
      swap_out_method
      begin
        yield
      ensure
        swap_back_method
      end
    end
    
    def swap_out_method
      row_selector = self.row_selector
      
      mysql_adapter.class_eval do
        alias_method(:__old_select_aliased_by_guillotine__, :select)
        public :__old_select_aliased_by_guillotine__

        define_method :select do |sql, name|
          begin
            row_selector.select(sql)
          # TODO: Make this exception handling better.  For instance,
          # we might want to:
          # 1. rescue from a SQLParseError, send it to the mysql
          #     database, and if it *does* succeed without a parse error, log it
          #     to a bug list. 
          # 2. rescue from a TableNotTracked error
          # 3. rescue from other exceptions, and log to the bug log
          rescue Exception
            __old_select_aliased_by_guillotine__(sql, name)
          end
        end
      end
    end
    
    def swap_back_method
      mysql_adapter.class_eval do
        alias_method(:select, :__old_select_aliased_by_guillotine__)
        undef :__old_select_aliased_by_guillotine__
        private :select
      end
    end
  end
end
