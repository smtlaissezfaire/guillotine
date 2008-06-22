
Guillotine.module_eval do
  treetop = File.dirname(__FILE__) + "/treetop"
  
  require "#{treetop}/primitives"
  require "#{treetop}/sql_helpers"
  require "#{treetop}/sql_row_support"
  require "#{treetop}/sql_key_value_pair"
  require "#{treetop}/sql_where_condition"
  require "#{treetop}/sql_limit"
  require "#{treetop}/sql_order_by_clause"
  require "#{treetop}/sql_from_clause"
  require "#{treetop}/sql_select_clause"
  require "#{treetop}/sql_select"
  require "#{treetop}/truncate"
  require "#{treetop}/sql_delete"
end
