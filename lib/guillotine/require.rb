module Guillotine
  class << self
    # Get rid of the require inherited from Polyglot. 
    # It doesn't seem to work anyway.
    undef :require
    
    # Create a custom require which will first try to use
    # Kernel.require, next try to load a treetop file,
    # and finally fail as usual, with a LoadError
    #
    # We could override Object.require, but we simply aren't
    # that pushy.
    def require(file, kernel=Kernel)
      kernel.require(file)
    rescue LoadError
      begin
        Treetop.load(file)
      rescue Errno::ENOENT
        raise(LoadError, "Could not load the file '#{file}' with a rb, treetop, or tt extension")
      end
    end
  end
end
