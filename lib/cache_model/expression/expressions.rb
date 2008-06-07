module CachedModel
  module Expression
    def self.simple_classes_with_corresponding_messages
      @simple_classes_with_corresponding_messages ||= { 
        :Equal => :==,
        :LessThan => :<,
        :GreaterThan => :>,
        :GreaterThanOrEqualTo => :>=,
        :LessThanOrEqualTo => :<=
      }
    end
    
    simple_classes_with_corresponding_messages.each do |class_name, message|
      unless const_defined?(class_name)
        klass = Class.new(Base) do
          define_method :to_lambda do
            new_lambda_with_message(message)
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
        new_lambda_with_message(:==)
      end
    end
    
    class IsNotNull < IsNull
      def to_lambda
        lambda { |obj| ! super.call(obj) }
      end
    end
    
    class Like < Base
      def to_lambda
        raise NotImplementedError
      end
    end
  end
end
