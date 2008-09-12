module Guillotine
  module DataStore
    class UnknownTable < StandardError; end
    class TableAlreadyExists < StandardError; end    
    
    class << self
      def __clear_all_tables!
        @data = nil
      end
      
      def data
        @data ||= { }
      end
      
      def tables
        data.keys
      end
      
      def table(table_name)
        data[sym(table_name)]
      end
      
      def create_table(table_name, options = { :if_exists => false })
        if !options[:if_exists] && table_exists?(table_name)
          raise TableAlreadyExists
        else
          data[sym(table_name)] = []
        end
      end
      
      def drop_table(table_name, options = { :if_exists => false })
        if options[:if_exists] || table_exists?(table_name)
          data.delete(sym(table_name))
        else
          raise UnknownTable
        end
      end
      
      def truncate_all_tables
        tables.each do |table|
          drop_table(table)
          create_table(table)
        end
      end
      
      def inspect
        "Singleton #{self}"
      end
      
    private
      
      def table_exists?(table_name)
        table(table_name) ? true : false
      end
      
      def sym(string_or_symbol)
        string_or_symbol.to_sym
      end
    end
  end
end
