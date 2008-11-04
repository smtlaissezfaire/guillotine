module Guillotine
  module Shell
    def self.start
      Main.do
    end
    
    dir = "#{File.dirname(__FILE__)}/shell"
    autoload :Command, "#{dir}/command"
    autoload :OutputFormatter, "#{dir}/output_formatter"
    
    module Main
      INTRODUCTORY_TEXT = File.read(File.dirname(__FILE__) + "/shell_introduction.txt")
      
      class << self
        def do
          puts(INTRODUCTORY_TEXT)
          
          loop do
            begin
              printf(">> ")
              Command.execute(gets)
            rescue => e
              output_error(e)
            end
          end
        end
        
        def output_error(e)
          puts e.message
        end
        
      private
        
        def puts(*args)
          Kernel.puts(*args)
        end
        
        def printf(*args)
          Kernel.printf(*args)
        end
        
        def gets(*args)
          Kernel.gets(*args).chomp
        end
      end
    end
  end
end
