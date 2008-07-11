
require "rubygems"
require "active_record"

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
          datastore.create_table(ar_class.table_name.to_sym)
          Guillotine::DataStore.initial_insert(ar_class.find(:all))
        end
        
      private
        
        def datastore
          Guillotine::DataStore
        end
      end
    end
  end
end

ActiveRecord::Base.instance_eval do
  extend Guillotine::ActiveRecord::Extensions
end
