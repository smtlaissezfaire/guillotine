module CacheModel
  class CachedModel
    def initialize(target)
      @target = target
    end
    
    def find(*args)
      if_no_excluded_options?(*args) do
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
    
    def if_no_excluded_options?(*args)
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
    
    def find_all_records
      @all_records ||= @target.find(:all).to_a
    end
    
    def all_records
      find_all_records
    end
    
    def find_by_id(id)
      all_records.find { |r| r.id == id.to_i }
    end
  end
end
