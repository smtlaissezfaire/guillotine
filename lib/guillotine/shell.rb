module Guillotine
  module Shell
    def self.start
      Main.do
    end
    
    module Main
      INTRODUCTORY_TEXT = <<-HERE
Welcome to Guillotine SQL
HERE
      
      def self.do
        Kernel.puts(INTRODUCTORY_TEXT)
        
        loop do
          begin
            Kernel.printf(">> ")
            Command.execute(Kernel.gets)
          rescue => e
            output_error(e)
          end
        end
      end
      
      def self.output_error(e)
        Kernel.puts e.message
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
