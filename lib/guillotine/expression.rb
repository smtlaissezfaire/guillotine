require File.dirname(__FILE__) + "/expression/base"
require File.dirname(__FILE__) + "/expression/expressions"
require File.dirname(__FILE__) + "/expression/select"
require File.dirname(__FILE__) + "/expression/from"
require File.dirname(__FILE__) + "/expression/order_by"
require File.dirname(__FILE__) + "/expression/limit"
require File.dirname(__FILE__) + "/expression/backtick_string"
require File.dirname(__FILE__) + "/expression/truncate"
require File.dirname(__FILE__) + "/expression/delete"


module Guillotine
  module Expression
    SYNTAX_CLASSES = { 
      :"="           => Equal,
      :"!="          => NotEqual,
      :<             => LessThan,
      :<=            => LessThanOrEqualTo,
      :>             => GreaterThan,
      :>=            => GreaterThanOrEqualTo,
      :"IS NULL"     => IsNull,
      :"IS NOT NULL" => IsNotNull,
      :AND           => Guillotine::ConjunctionConditionNode,
      :OR            => Guillotine::DisjunctionConditionNode
    } unless defined?(SYNTAX_CLASSES)
    
    def self.find_class_for(joiner)
      if syntax_class = SYNTAX_CLASSES[joiner]
        syntax_class
      else
        raise "Unknown joiner #{joiner}"
      end
    end
  end
end