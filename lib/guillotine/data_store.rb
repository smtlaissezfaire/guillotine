module Guillotine
  module DataStore
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
      
      def add_table(tbl_name)
        data[sym(tbl_name)] = []
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
