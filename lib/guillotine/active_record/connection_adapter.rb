module Guillotine
  module ActiveRecord
    class ConnectionAdapter
      module Proxy
        def self.included(other_mod)
          other_mod.extend(ClassMethods)
        end
        
        module ClassMethods
          def proxy(ivar)
            class_eval do
              def respond_to?(sym)
                super || __proxy_ivar__.respond_to?(sym)
              end
              
            private
              
              define_method :__proxy_ivar__ do
                instance_variable_get("@#{ivar}")
              end
              
              def method_missing(sym, *args, &blk)
                if __proxy_ivar__.respond_to?(sym)
                  __proxy_ivar__.send(sym, *args, &blk)
                else
                  super
                end
              end
            end
          end
        end
      end
      
      def initialize(active_record_connection)
        @connection = active_record_connection
      end
      
      attr_reader :connection
      
      include Proxy
      proxy :connection
    end
  end
end
