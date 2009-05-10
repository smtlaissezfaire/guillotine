module Guillotine
  module Expressions
    class UnknownSyntaxError < StandardError; end
    
    class << self
      def find_class_for(joiner)
        syntax_class = syntax_classes[joiner.to_sym]        
        raise(UnknownSyntaxError, "Unknown joiner '#{joiner}'") unless syntax_class
        syntax_class
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
    autoload :Equal,                "#{dir}/equal"
    autoload :LessThan,             "#{dir}/less_than"
    autoload :GreaterThan,          "#{dir}/greater_than"
    autoload :GreaterThanOrEqualTo, "#{dir}/greater_than_or_equal_to"
    autoload :LessThanOrEqualTo,    "#{dir}/less_than_or_equal_to"
    autoload :NotEqual,             "#{dir}/not_equal"
    autoload :IsNull,               "#{dir}/is_null"
    autoload :IsNotNull,            "#{dir}/is_not_null"
    autoload :Select,               "#{dir}/select"
    autoload :From,                 "#{dir}/from"
    autoload :OrderBy,              "#{dir}/order_by"
    autoload :GroupBy,              "#{dir}/group_by"
    autoload :Limit,                "#{dir}/limit"
    autoload :Truncate,             "#{dir}/truncate"
    autoload :DeleteStatement,      "#{dir}/delete"
    autoload :SelectExpression,     "#{dir}/select_expression"
    autoload :Insert,               "#{dir}/insert"
    autoload :CreateTable,          "#{dir}/create_table"
    autoload :TableDisplayer,       "#{dir}/table_displayer"
  end
end
