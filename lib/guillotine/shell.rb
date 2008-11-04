module Guillotine
  module Shell
    def self.start
      Main.do
    end
    
    module Main
      INTRODUCTORY_TEXT = <<-HERE
Welcome to Guillotine SQL
HERE
      
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
          Kernel.gets(*args)
        end
      end
    end
    
    class Command
      EXIT_SEQUENCE = "exit"
      
      def self.execute(command)
        new(command).execute
      end
      
      def initialize(command)
        @command = command
      end
      
      def execute
        if @command == EXIT_SEQUENCE
          Kernel.exit
        else
          OutputFormatter.format(Guillotine.execute(@command))
        end
      end
    end
    
    class OutputFormatter
      def self.format(obj)
        new.format(obj)
      end
      
      def format(obj)
        obj.to_s
      end
    end
  end
end
