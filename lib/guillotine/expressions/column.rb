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
    end
  end
end
