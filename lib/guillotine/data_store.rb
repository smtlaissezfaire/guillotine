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
      
      def create_table(table_name)
        if table(table_name)
          raise TableAlreadyExists
        else
          data[sym(table_name)] = []
        end
      end
      
      def drop_table(table_name)
        if table(table_name)
          data.delete(sym(table_name))
        else
          raise UnknownTable
        end
      end
      
      def inspect
        "Singleton #{self}"
      end
      
    private
      
      def sym(string_or_symbol)
        string_or_symbol.to_sym
      end
    end
  end
end
