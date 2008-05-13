module CacheModel
  class CachedModel
    def initialize(target)
      @target = target
    end
    
    def find(*args)
      if_excluded_options?(*args) do
        case args.first
        when :all
          all_records
        when :first
          first_finder(args[1] || { })
        else
          find_by_id(args.first)
        end
      end
    end
    
    attr_reader :all_records
    attr_reader :target
    
  private
    
    def if_excluded_options?(*args)
      if args.size == 2 && keys = args[1].keys
        if keys.include?(:include)
          target.find(*args)
        else
          yield
        end
      else
        yield
      end
    end
    
    def first_finder(options={ })
      if options.keys.include?(:conditions)
        conditions = ConditionConverter.parse(options[:conditions]).to_proc
        find_all_records.find(&conditions)
      else
        find_all_records.first
      end
    end
    
    class ConditionConverter
      class << self
        def parse(hash_or_array)
          new_subtype(hash_or_array).parse
        end
        
        def new_subtype(hash_or_array)
          case hash_or_array
          when Array
            ArrayConditionConverter.new(hash_or_array)
          when Hash
            HashConditionConverter.new(hash_or_array)
          end
        end
      end
        
      def to_proc
        @lambda
      end
    end
    
    class HashConditionConverter < ConditionConverter
      def initialize(hash)
        @hash = hash
      end
      
      attr_reader :hash
      
      def parse
        @lambda = lambda do |obj|
          result = false
          
          @hash.each do |key, value|
            result = (obj.send(key) == value)
          end
          
          result
        end
      end
    end
    
    class ArrayConditionConverter < ConditionConverter
      def initialize(array)
        @array = array
      end
      
      attr_reader :array
      
      def parse
        @lambda = lambda do |obj|
          map_paramaters { |message, condition, value, negation| 
            if negation
              obj.send(message) != value
            else
              obj.send(message).send(condition, value)
            end
          }
        end
      end
      
      def map_paramaters
        negation = false
        array[0] =~ /([a-zA-Z1-9_]+)\s*(\=|\!\=)\s*\?/
        if $2 == "="
          condition = :==
        else
          condition = $2.strip
          if condition == "!="
            condition = :==
            not_condition = true
          end
        end
        
        yield $1.strip, condition, array[1], not_condition
      end
      
    end
    
    def find_all_records
      @all_records ||= @target.find(:all).to_a
    end
    
    def all_records
      find_all_records
    end
    
    def find_by_id(id)
      all_records.find { |r| r.id == id }
    end
  end
end
