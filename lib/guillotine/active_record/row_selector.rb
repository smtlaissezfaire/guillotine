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
          Guillotine::DataStore.create_table(table_name)
          Guillotine::DataStore.initial_insert(table_name, ::ActiveRecord::Base.connection.__old_select_aliased_by_guillotine__("SELECT * FROM #{table_name}"))
        end
      end
    end
  end
end
