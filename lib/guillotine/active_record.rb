module Guillotine
  module ActiveRecord
    dir = File.dirname(__FILE__) + "/active_record"
    
    require                            "#{dir}/extensions"
    autoload :TableAdministrator,      "#{dir}/extensions"
  end
end
