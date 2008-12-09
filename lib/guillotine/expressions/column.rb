module Guillotine
  module Expressions
    class Column
      def initialize(column)
        set_column_and_table_name(column)
      end
      
      attr_accessor :table_name
      attr_reader :column_name
      
      def to_sql
        if table_name
          "#{table_name}.#{column_name}"
        else
          column_name.to_s
        end
      end
      
      def ==(other)
        both_have_tables?(other) ? eql?(other) : same_column_name?(other)
      end
      
      def eql?(other)
        same_column_name?(other) && same_table_name?(other)
      end

      def primary_key?
        @primary_key ||= false
      end

      def auto_increment?
        @auto_increment ||= false
      end

      attr_writer :primary_key
      attr_writer :auto_increment

    protected
      
      def table_name?
        @table_name ? true : false
      end
      
    private

      def set_column_and_table_name(column)
        column = column.to_s
        
        if column.include?(".")
          @table_name, @column_name = column.split(".")
          @table_name = to_lowercase_sym(@table_name)
        else
          @column_name = column.to_s
        end
        
        @column_name = to_lowercase_sym(@column_name)
      end
      
      def to_lowercase_sym(string)
        string.downcase.to_sym
      end
      
      def both_have_tables?(other)
        table_name? && other.table_name?
      end
      
      def same_table_name?(other)
        @table_name == other.table_name
      end
      
      def same_column_name?(second)
        @column_name == second.column_name
      end
    end
  end
end
