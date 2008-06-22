module Guillotine
  module Expression
    def self.classes_with_comparisons
      @classes_with_comparisons ||= { 
        :Equal                => :==,
        :LessThan             => :<,
        :GreaterThan          => :>,
        :GreaterThanOrEqualTo => :>=,
        :LessThanOrEqualTo    => :<=
      }
    end
    
    classes_with_comparisons.each do |class_name, comparison|
      unless const_defined?(class_name)
        klass = Class.new(Base) do
          define_method :to_lambda do
            new_lambda_with_comparison(comparison)
          end
        end
        
        const_set(class_name, klass) 
      end
    end

    class NotEqual < Equal
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
    
    class IsNull < Base
      def initialize(key)
        super(key, nil)
      end
      
      def to_lambda
        new_lambda_with_comparison(:==)
      end
    end
    
    class IsNotNull < IsNull
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
  end
end
