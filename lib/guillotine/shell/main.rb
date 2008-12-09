require "readline"

module Guillotine
  module Shell
    module Main
      INTRODUCTORY_TEXT = File.read(File.dirname(__FILE__) + "/introduction.txt")
      READLINE_PROMPT = ">> "
      
      class << self
        def do
          puts(INTRODUCTORY_TEXT)
          
          loop do
            begin
              Command.execute(readline(READLINE_PROMPT))
            rescue => e
              output_error(e)
            end
          end
        end
        
        def output_error(e)
          puts e.message
        end
        
      private
        
        def readline(line)
          Readline.readline(line, true).chomp
        end
        
        def puts(*args)
          Kernel.puts(*args)
        end
      end
    end
  end
end

