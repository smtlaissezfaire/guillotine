module Guillotine
  module ActiveRecord
    module Extensions
      def guillotine_model
        TableAdministrator.add_table(self)
      end
    end
    
    class TableAdministrator
      class << self
        def add_table(ar_class)
          TableAdder.new(ar_class).add!
        end
        
        class TableAdder
          def initialize(ar_class)
            @ar_class = ar_class
          end
          
          def add!
            datastore.create_table(table_name, :if_exists => true)
            Guillotine::DataStore.initial_insert(table_name, @ar_class.find(:all))
          end
          
        private
          
          def table_name
            @table_name ||= @ar_class.table_name.to_sym
          end
          
          def datastore
            Guillotine::DataStore
          end
        end
      end
    end
  end
end

ActiveRecord::Base.instance_eval do
  extend Guillotine::ActiveRecord::Extensions
end
