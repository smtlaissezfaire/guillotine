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
        DataStore.table(Guillotine.execute(sql).from.table_name)
      end
      
      def insert_sql(sql)
        insert = Guillotine.execute(sql)
        insert.call
      end
    end
  end
end
