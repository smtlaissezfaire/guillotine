module Guillotine
  module Expressions
    class TableDisplayer
      def initialize(datastore)
        @datastore = datastore
      end
      
      attr_reader :datastore
      
      def to_sql
        "SHOW TABLES"
      end
      
      def call
        @datastore.table_names.map do |tbl_name|
          { :table_name => tbl_name }
        end
      end
      
      def ==(other)
        other.respond_to?(:datastore) ?
          @datastore.equal?(other.datastore) : false
      end
      
      alias_method :eql?, :==
    end
  end
end
