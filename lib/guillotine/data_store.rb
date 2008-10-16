module Guillotine
  module DataStore
    class UnknownTable < StandardError; end
    class TableAlreadyExists < StandardError; end
    
    class Table < Array
      class PrimaryKeyError < StandardError
        ERROR_MESSAGE = "A Primary Key must be specified with auto-increment => true"
        
        def message
          ERROR_MESSAGE
        end
      end
      
      def initialize(table_name, schema_options={ }, rows=[])
        @table_name = table_name.to_sym
        @schema_options = schema_options
        check_schema_options
        super(rows)
      end
      
      def <<(record)
        if auto_increment?
          super(record.merge(primary_key => next_autoincrement_id))
        else
          super
        end
      end
      
      attr_reader :table_name
      attr_reader :schema_options
      
      def auto_increment?
        @schema_options[:auto_increment]
      end
      
      def primary_key
        @schema_options[:primary_key]
      end
      
    private
      
      def next_autoincrement_id
        size + 1
      end
      
      def check_schema_options
        if @schema_options[:auto_increment] && !@schema_options[:primary_key]
          raise PrimaryKeyError
        end
      end
    end
    
    class << self
      
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
