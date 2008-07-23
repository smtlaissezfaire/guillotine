module Guillotine
  module Conditions
    dir = File.dirname(__FILE__) + "/conditions"
    
    autoload :Base,          "#{dir}/base"
    autoload :AndCondition,  "#{dir}/and_condition"
    autoload :OrCondition,   "#{dir}/or_condition"
  end
end
