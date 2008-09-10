module Guillotine
  module Expressions
    class Column
      def initialize(column)
        column_as_string = column.to_s
        
        if column_as_string.include?(".")
          @table_name, @column_name = column_as_string.split(".").map { |col| col.to_sym }
        else
          @column_name = column.to_sym
        end
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
        if both_have_tables?(other)
          eql?(other)
        else
          same_column_name?(other)
        end
      end
      
      def eql?(other)
        same_column_name?(other) && same_table_name?(other)
      end
      
   protected
      
      def table_name?
        @table_name ? true : false
      end
      
    private
      
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
