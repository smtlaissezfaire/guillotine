module Guillotine
  module ActiveRecord
    class RowSelector
      # TODO: Refactor the shit out of this
      def select(sql)
        parsed_sql = Guillotine.execute(sql)
        table_name = parsed_sql.from.table_names.to_a.first
        if table = Guillotine::DataStore.table(:users)
          parsed_sql.call(table)
        else
          raise Guillotine::Exceptions::TableNotTracked, "The #{table_name} table is not tracked by Guillotine"          
        end
      end
    end
  end
end
