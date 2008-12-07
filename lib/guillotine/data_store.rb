module Guillotine
  module DataStore
    class Schema
      def initialize
        @columns = []
      end

      attr_accessor :table, :columns

      def primary_key
        columns.detect { |column| column.primary_key? }
      end

      def primary_key?
        primary_key ? true : false
      end

      def auto_incrementing?
        primary_key? ? primary_key.auto_incrementing? : false
      end
    end

    class UnknownTable < StandardError; end
    class TableAlreadyExists < StandardError; end
    
    class Table < Array
      class PrimaryKeyError < StandardError; end
      
      def initialize(table_name, schema_options={ }, rows=[])
        @table_name = table_name.to_sym
        @schema_options = schema_options
        @last_autoincrement_id = 0
        check_schema_options
        super(rows)
      end
      
      def <<(record)
        if auto_increment? && primary_key_not_present?(record)
          new_record = record.merge(primary_key => next_autoincrement_id)
        else
          new_record = record
        end
        
        check_primary_key_validity(record)
        
        super(new_record)
        @last_autoincrement_id += 1
      end
      
      attr_reader :table_name
      attr_reader :schema_options
      
      def auto_increment?
        @schema_options[:auto_increment]
      end
      
      def primary_key
        @schema_options[:primary_key]
      end
      
      def truncate
        clear
        @last_autoincrement_id = 0
      end
      
    private
      
      def check_primary_key_validity(a_row)
        if detect { |row| row[:id] == a_row[:id] }
          raise(PrimaryKeyError, "A primary key with id 1 has already been taken")
        end
      end
      
      def primary_key_not_present?(record)
        !record.has_key?(primary_key)
      end
      
      def next_autoincrement_id
        @last_autoincrement_id + 1
      end
      
      def check_schema_options
        if @schema_options[:auto_increment] && !@schema_options[:primary_key]
          raise PrimaryKeyError, "A Primary Key must be specified with auto-increment => true"
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
      
      def table_names
        data.keys
      end
      
      def tables
        table_names.map { |name| table(name) }
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
