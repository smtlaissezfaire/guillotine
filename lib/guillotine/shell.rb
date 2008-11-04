module Guillotine
  module Shell
    def self.start
      Main.do
    end
    
    dir = "#{File.dirname(__FILE__)}/shell"
    autoload :Main, "#{dir}/main"
    autoload :Command, "#{dir}/command"
    autoload :OutputFormatter, "#{dir}/output_formatter"
  end
end
