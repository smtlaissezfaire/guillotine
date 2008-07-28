module Guillotine
  module ActiveRecord
    class RowSelector
      # TODO: Refactor the shit out of this
      def select(sql)
        parsed_sql = Guillotine.execute(sql)
        table_name = parsed_sql.from.table_names.to_a.first.to_sym
        
        
        if table = Guillotine::DataStore.table(table_name)
          parsed_sql.call(table)
        else
          create_table(table_name)
          insert(table_name)
        end
      end
      
    private
      
      def insert(table_name)
        datastore.initial_insert(table_name, original_select("SELECT * FROM `#{table_name}`"))
      end
      
      def create_table(table_name)
        datastore.create_table(table_name)
      end
      
      def original_select(query)
        connection.__old_select_aliased_by_guillotine__(query)
      end
      
      def connection
        ::ActiveRecord::Base.connection
      end
      
      def datastore
        Guillotine::DataStore
      end
    end
  end
end
