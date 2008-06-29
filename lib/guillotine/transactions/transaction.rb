module Guillotine
  module Transactions
    class Transaction
      def initialize
        Store.register(self)
      end
      
      def commit
        remove_instance
      end
      
    private
      
      def remove_instance
        Store.remove_instance(self)
      end
    end
  end
end
