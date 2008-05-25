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
        narrow_records(conditions).first
      else
        find_all_records.first
      end
    end
    
    def narrow_records(conditions, result_set=all_records)
      if conditions.empty?
        return result_set
      else
        condition = conditions.pop
        narrow_records(conditions,
                       result_set.find_all(&condition))
      end
    end
    
    def conditions
      ConditionConverter.parse(@condition_options)
    end
    
    def all_records
      @all_records ||= @target.find(:all).to_a
    end
    
    alias_method :find_all_records, :all_records
    
    def find_by_id(id)
      all_records.find { |r| r.id == id.to_i }
    end
  end
end
