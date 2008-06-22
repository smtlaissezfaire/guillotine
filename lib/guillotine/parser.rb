
# Need to module eval here to get the require from
# Guillotine
Guillotine.module_eval do
  parser = File.dirname(__FILE__) + "/parser"
  
  require "#{parser}/primitives"
  require "#{parser}/sql_helpers"
  require "#{parser}/sql_row_support"
  require "#{parser}/sql_key_value_pair"
  require "#{parser}/sql_where_condition"
  require "#{parser}/sql_limit"
  require "#{parser}/sql_order_by_clause"
  require "#{parser}/sql_from_clause"
  require "#{parser}/sql_select_clause"
  require "#{parser}/sql_select"
  require "#{parser}/truncate"
  require "#{parser}/sql_delete"
end