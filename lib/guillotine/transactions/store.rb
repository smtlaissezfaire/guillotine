module Guillotine
  module Transactions
    module Store
      class << self
        def instances
          @instances ||= []
        end
        
        def register(instance)
          instances << instance
        end
        
        # This is only used for tests.  Don't
        # Call unless you want to lose all of the
        # current transactions, plus any commits (inserts, updates,
        # and/or deletes) which may be occuring
        def clear_instances!
          @instances = nil
        end
      end
    end
  end
end
