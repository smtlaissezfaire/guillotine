expression = File.dirname(__FILE__) + "/expression"

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


Guillotine.autoload             :BackTickString,       "#{expression}/backtick_string"
Guillotine::Expression.autoload :Base,                 "#{expression}/base"
Guillotine::Expression.autoload :Equal,                "#{expression}/expressions"
Guillotine::Expression.autoload :LessThan,             "#{expression}/expressions"
Guillotine::Expression.autoload :GreaterThan,          "#{expression}/expressions"
Guillotine::Expression.autoload :GreaterThanOrEqualTo, "#{expression}/expressions"
Guillotine::Expression.autoload :LessThanOrEqualTo,    "#{expression}/expressions"
Guillotine::Expression.autoload :NotEqual,             "#{expression}/expressions"
Guillotine::Expression.autoload :IsNull,               "#{expression}/expressions"
Guillotine::Expression.autoload :IsNotNull,            "#{expression}/expressions"
Guillotine::Expression.autoload :Select,               "#{expression}/select"
Guillotine::Expression.autoload :From,                 "#{expression}/from"
Guillotine::Expression.autoload :OrderBy,              "#{expression}/order_by"
Guillotine::Expression.autoload :Limit,                "#{expression}/limit"
Guillotine::Expression.autoload :Truncate,             "#{expression}/truncate"
Guillotine::Expression.autoload :TopLevelExpression,   "#{expression}/delete"
Guillotine::Expression.autoload :Delete,               "#{expression}/delete"
Guillotine::Expression.autoload :SelectExpression,     "#{expression}/select_expression"
