module Guillotine
  module DataStore
    class Table < Array
      class PrimaryKeyError < StandardError; end

      AUTO_INCREMENT_DEFAULT = true
      DEFAULT_PRIMARY_KEY_ID = :id
      
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
        if primary_key_column?
          primary_key_column.auto_increment?
        elsif columns?
          false
        else
          AUTO_INCREMENT_DEFAULT
        end
      end

      alias_method :auto_incrementing?, :auto_increment?
      
      def primary_key
        if primary_key_column?
          primary_key_column.column_name
        elsif columns?
          nil
        else
          DEFAULT_PRIMARY_KEY_ID
        end
      end

      def truncate
        clear
        @last_autoincrement_id = 0
      end
      
    private

      def primary_key_column
        if columns?
          columns.detect { |col| col.primary_key? }
        end
      end

      def primary_key_column?
        primary_key_column ? true : false
      end
      
      def columns?
        columns ? true : false
      end

      def columns
        @schema_options[:columns]
      end
      
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

