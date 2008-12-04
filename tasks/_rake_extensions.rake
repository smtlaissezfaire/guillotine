module Rake
  class Task
    # used to insert a dependency into the front of a list
    def insert_dependency(dependency)
      @prerequisites = [dependency, @prerequisites].flatten
    end
  end
end
