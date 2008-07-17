module Guillotine
  module ActiveRecord
    class ConnectionAdapter
      module Proxy
        def proxy!
          class_eval do
            def respond_to?(sym)
              super || @connection.respond_to?(sym)
            end
            
          private
            
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
      
      def initialize(active_record_connection)
        @connection = active_record_connection
      end
      
      attr_reader :connection
      
      extend Proxy
      self.proxy!
    end
  end
end
