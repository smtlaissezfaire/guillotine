module Guillotine
  module ActiveRecord
    class ConnectionAdapter
      def initialize(active_record_connection)
        @connection = active_record_connection
      end
      
      attr_reader :connection
      
      def respond_to?(sym)
        super || @connection.respond_to?(sym)
      end
      
      def method_missing(sym, *args, &blk)
        if @connection.respond_to?(sym)
          @connection.send(sym, *args, &blk)
        else
          super
        end
      end
    end
  end
end
