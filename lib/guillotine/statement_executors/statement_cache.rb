module Guillotine
  module StatementExecutors
    module StatementCache
      class << self
        def cache
          @cache ||= { }
        end

        def add(key, value)
          self.[]=(key, value)
        end

        def [](key)
          cache[key.to_sym]
        end

        def []=(key, value)
          cache[key.to_sym] = value
        end

        def add_or_find(key)
          if result = self.[](key)
            result
          else
            self.[]=(key, yield)
          end
        end

        def empty_cache!
          @cache = { }
        end
      end
    end
  end
end
