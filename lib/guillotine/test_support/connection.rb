module Guillotine
  module TestSupport
    class Connection
      def initialize(datastore = Guillotine::DataStore)
        @datastore = datastore
      end
      
      attr_reader :datastore
      
      def rollback!
        @datastore.truncate_all_tables!
      end
      
      def select(sql)
        select = parse_sql(sql)
        table_name = select.from.table_name
        select.call(find_table_in_datstore(table_name))
      end
      
      def insert_sql(sql)
        insert = parse_sql(sql)
        collection = find_table_in_datstore(insert.into)
        insert.call(collection)
      end
      
    private
      
      def find_table_in_datstore(table_name)
        @datastore.table(table_name)
      end
      
      def parse_sql(sql)
        Guillotine.parse(sql)
      end
    end
  end
end
