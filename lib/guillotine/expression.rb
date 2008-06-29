expression = File.dirname(__FILE__) + "/expression"

require "#{expression}/base"
require "#{expression}/expressions"
require "#{expression}/select"
require "#{expression}/from"
require "#{expression}/order_by"
require "#{expression}/limit"
require "#{expression}/backtick_string"
require "#{expression}/truncate"
require "#{expression}/delete"
require "#{expression}/select_expression"

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
