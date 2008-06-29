module Guillotine
  module Transactions
    class Transaction
      def initialize
        generate_transaction_id
        register
      end
      
      def commit
        unregister
      end
      
      def rollback
        unregister
      end
      
      def transaction_id
        @transaction_id ||= IdGenerator.generate
      end
      
      alias_method :generate_transaction_id, :transaction_id
      
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
