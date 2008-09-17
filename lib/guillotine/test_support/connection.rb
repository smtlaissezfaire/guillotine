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
    end
  end
end
