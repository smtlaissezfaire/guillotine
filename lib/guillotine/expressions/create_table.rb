module Guillotine
  module Expressions
    class CreateTable
      TWO_SPACES         = "  "
      COLUMN_INDENTATION = TWO_SPACES
      NEWLINE            = "\n"
      COMMA              = ","
      COLUMN_SEPARATOR   = "#{COMMA}#{NEWLINE}"
      
      class InvalidTableOption < StandardError; end
      
      def initialize(table_name, columns)
        check_columns(columns)

        @table_name = table_name.to_sym
        @columns    = columns
      end
      
      attr_reader :columns
      attr_reader :table_name
      
      def call(datastore = Guillotine::DataStore)
        datastore.create_table(table_name, :columns => @columns)
      end
      
      def to_sql
        "CREATE TABLE `#{table_name}` (\n#{columns_to_sql}\n)"
      end
      
      def ==(other)
        if comparable?(other)
          columns == other.columns && 
            table_name == other.table_name
        else
          false
        end
      end
      
    private
      
      def comparable?(other)
        other.respond_to?(:columns) &&
          other.respond_to?(:table_name)
      end
      
      def columns_to_sql
        columns.map { |col| "#{COLUMN_INDENTATION}#{col.to_sql}" }.join(COLUMN_SEPARATOR)
      end

      def check_columns(columns)
        if columns.empty?
          raise InvalidTableOption, "A table must have one or more columns"
        end
      end
    end
  end
end
