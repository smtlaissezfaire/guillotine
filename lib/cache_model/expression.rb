require File.dirname(__FILE__) + "/expression/base"
require File.dirname(__FILE__) + "/expression/expressions"

module CachedModel
  module Expression
    SYNTAX_CLASSES = { 
      "="  => Equal,
      "!=" => NotEqual,
      "<"  => LessThan,
      "<=" => LessThanOrEqualTo,
      ">"  => GreaterThan,
      ">=" => GreaterThanOrEqualTo,
      "IS NOT NULL" => IsNotNull
    }
    
    def self.find_class_for(joiner)
      if syntax_class = SYNTAX_CLASSES[joiner]
        syntax_class
      else
        raise "Unknown joiner #{joiner}"
      end
    end
  end
end
