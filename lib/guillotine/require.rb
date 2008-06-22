module Guillotine
  class << self
    # Get rid of the require inherited from Polyglot. 
    # It doesn't seem to work anyway.
    undef :require
    
    def require(file, kernel=Kernel)
      kernel.require(file)
    rescue LoadError
      begin
        Treetop.load(file)
      rescue Errno::ENOENT
        raise_require_error(file)
      end
    end
    
  private
    
    def raise_require_error(file)
      raise(LoadError, "Could not load the file '#{file}' with a rb, treetop, or tt extension")
    end
  end
end
