module Guillotine
  module Shell
    dir = "#{File.dirname(__FILE__)}/shell"
    
    autoload :Main,            "#{dir}/main"
    autoload :Command,         "#{dir}/command"
    autoload :OutputFormatter, "#{dir}/output_formatter"
    
    def self.start
      Main.do
    end
  end
end
