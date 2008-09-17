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
        DataStore.table(parse_sql(sql).from.table_name)
      end
      
      def insert_sql(sql)
        insert = parse_sql(sql)
        insert.call
      end
      
    private
      
      def parse_sql(sql)
        Guillotine.execute(sql)
      end
    end
  end
end
