module Guillotine
  module ActiveRecord
    dir = File.dirname(__FILE__) + "/active_record"
    
    require                            "#{dir}/extensions"
    autoload :ConnectionAdapter,       "#{dir}/connection_adapter"
    autoload :RowSelector,             "#{dir}/row_selector"
  end
end
