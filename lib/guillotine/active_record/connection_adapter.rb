module Guillotine
  module ActiveRecord
    class ConnectionAdapter
      def initialize(active_record_connection)
        @connection = active_record_connection
      end
      
      attr_reader :connection
      
      include TransparentProxy
      proxy :connection
    end
  end
end
