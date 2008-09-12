module Guillotine
  module TestSupport
    class Connection
      def initialize(datastore = Guillotine::DataStore)
        @datastore = datastore
      end
      
      attr_reader :datastore
      
      def rollback!
        @datastore.truncate_all_tables
      end
    end
  end
end
