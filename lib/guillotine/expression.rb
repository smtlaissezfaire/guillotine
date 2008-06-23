require File.dirname(__FILE__) + "/expression/base"
require File.dirname(__FILE__) + "/expression/expressions"
require File.dirname(__FILE__) + "/expression/select"
require File.dirname(__FILE__) + "/expression/from"
require File.dirname(__FILE__) + "/expression/order_by"
require File.dirname(__FILE__) + "/expression/limit"
require File.dirname(__FILE__) + "/expression/backtick_string"
require File.dirname(__FILE__) + "/expression/truncate"
require File.dirname(__FILE__) + "/expression/delete"
require File.dirname(__FILE__) + "/expression/select_expression"


module Guillotine
  module Expression
    class UnknownSyntaxError < StandardError; end
    
    class << self
      def find_class_for(joiner)
        if syntax_class = syntax_classes[joiner.to_sym]
          syntax_class
        else
          raise UnknownSyntaxError, "Unknown joiner '#{joiner}'"
        end
      end
      
    private
      
      def syntax_classes
        @syntax_classes ||= { 
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
        }
      end
    end
  end
end
