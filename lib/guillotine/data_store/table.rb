module Guillotine
  module DataStore
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
  end
end

