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
      if args.size == 2 && args_include_excluded_keys?(args[1])
        target.find(*args)
      else
        yield
      end
    end
    
    def args_include_excluded_keys?(arg)
      excluded_keys.each do |key|
        return true if arg.keys.include?(key)
      end
      
      false
    end
    
    def excluded_keys
      [:include]
    end
    
    def first_finder(options={ })
      if options.keys.include?(:conditions)
        @condition_options = options[:conditions]
        narrow_records(conditions)
      else
        find_all_records.first
      end
    end
    
    def narrow_records(conditions)
      conditions.each do |condition|
        return find_all_records.find(&condition.to_proc)
      end
    end
    
    def conditions
      ConditionConverter.parse(@condition_options)
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
