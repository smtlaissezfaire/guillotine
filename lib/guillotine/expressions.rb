module Guillotine
  module Expressions
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
        @syntax_classes ||= find_symbol_to_syntax_class_mapping
      end
      
      def find_symbol_to_syntax_class_mapping
        hash = { }
        classes.map do |klass|
          operator = klass.const_get(:SQL_OPERATOR).to_sym
          hash[operator] = klass
        end
        hash
      end
      
      def classes
        [
          Equal,
          NotEqual,
          LessThan,
          LessThanOrEqualTo,
          GreaterThan,
          GreaterThanOrEqualTo,
          IsNull,
          IsNotNull,
          Guillotine::Conditions::AndCondition,
          Guillotine::Conditions::OrCondition
        ]
      end
    end
    
    dir = File.dirname(__FILE__) + "/expressions"
    autoload :BacktickString,       "#{dir}/backtick_string"
    autoload :Base,                 "#{dir}/base"
    autoload :TopLevelExpression,   "#{dir}/top_level_expression"
    autoload :Column,               "#{dir}/column"
    autoload :Equal,                "#{dir}/expressions"
    autoload :LessThan,             "#{dir}/expressions"
    autoload :GreaterThan,          "#{dir}/expressions"
    autoload :GreaterThanOrEqualTo, "#{dir}/expressions"
    autoload :LessThanOrEqualTo,    "#{dir}/expressions"
    autoload :NotEqual,             "#{dir}/expressions"
    autoload :IsNull,               "#{dir}/expressions"
    autoload :IsNotNull,            "#{dir}/expressions"
    autoload :Select,               "#{dir}/select"
    autoload :From,                 "#{dir}/from"
    autoload :OrderBy,              "#{dir}/order_by"
    autoload :GroupBy,              "#{dir}/group_by"
    autoload :Limit,                "#{dir}/limit"
    autoload :Truncate,             "#{dir}/truncate"
    autoload :DeleteStatement,      "#{dir}/delete"
    autoload :SelectExpression,     "#{dir}/select_expression"
    autoload :Insert,               "#{dir}/insert"
  end
end
