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
    
    extend Using
    using :BacktickString
    using :Base
    using :TopLevelExpression
    using :Column
    using :Equal
    using :LessThan
    using :GreaterThan
    using :GreaterThanOrEqualTo
    using :LessThanOrEqualTo
    using :NotEqual
    using :IsNull
    using :IsNotNull
    using :Select
    using :From
    using :OrderBy
    using :GroupBy
    using :Limit
    using :Truncate
    using :DeleteStatement
    using :SelectExpression
    using :Insert
    using :CreateTable
    using :TableDisplayer
  end
end
