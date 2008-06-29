module Guillotine
  module Transactions
    class Transaction
      def initialize
        register
      end
      
      def commit
        unregister
      end
      
      def rollback
        unregister
      end
      
    private
      
      def unregister
        Store.remove_instance(self)
      end
      
      def register
        Store.register(self)
      end
    end
  end
end
