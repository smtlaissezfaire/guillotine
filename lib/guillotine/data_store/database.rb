module Guillotine
  module DataStore
    module Database
      DEFAULT_TABLE_OPTIONS = {
        :primary_key => :id,
        :auto_increment => true
      }
      
      def __clear_all_tables!
        @data = nil
      end
      
      def data
        @data ||= { }
      end
      
      def table_names
        data.keys
      end
      
      def tables
        table_names.map { |name| table(name) }
      end
      
      def table(table_name)
        data[sym(table_name)]
      end
      
      def create_table(table_name, options = { :force => false })
        if !options[:force] && table_exists?(table_name)
          raise TableAlreadyExists
        else
          table_name = sym(table_name)
          data[table_name] = Table.new(table_name, DEFAULT_TABLE_OPTIONS)
        end
      end
      
      def drop_table(table_name, options = { :if_exists => false })
        if options[:if_exists] || table_exists?(table_name)
          data.delete(sym(table_name))
        else
          raise UnknownTable
        end
      end
      
      def truncate_all_tables!
        tables.each { |tbl| tbl.truncate }
      end
      
      def inspect
        "Singleton #{self}"
      end
      
    private
      
      def table_exists?(table_name)
        table(table_name) ? true : false
      end
      
      def sym(string_or_symbol)
        string_or_symbol.to_s.downcase.to_sym
      end
    end
  end
end
