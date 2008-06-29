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

    
    expression = File.dirname(__FILE__) + "/expression"

    autoload :BacktickString,       "#{expression}/backtick_string"
    autoload :Base,                 "#{expression}/base"
    autoload :Equal,                "#{expression}/expressions"
    autoload :LessThan,             "#{expression}/expressions"
    autoload :GreaterThan,          "#{expression}/expressions"
    autoload :GreaterThanOrEqualTo, "#{expression}/expressions"
    autoload :LessThanOrEqualTo,    "#{expression}/expressions"
    autoload :NotEqual,             "#{expression}/expressions"
    autoload :IsNull,               "#{expression}/expressions"
    autoload :IsNotNull,            "#{expression}/expressions"
    autoload :Select,               "#{expression}/select"
    autoload :From,                 "#{expression}/from"
    autoload :OrderBy,              "#{expression}/order_by"
    autoload :Limit,                "#{expression}/limit"
    autoload :Truncate,             "#{expression}/truncate"
    autoload :TopLevelExpression,   "#{expression}/delete"
    autoload :Delete,               "#{expression}/delete"
    autoload :SelectExpression,     "#{expression}/select_expression"
  end
end
