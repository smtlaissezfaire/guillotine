module Guillotine
  module Shell
    class Command
      EXIT_SEQUENCE = "exit"
      DEBUG_SEQUENCE = "debug"
      
      def self.execute(command)
        new(command).execute
      end
      
      def initialize(command)
        @command = command
      end
      
      def execute
        if @command == EXIT_SEQUENCE
          exit
        elsif @command =~ /^#{DEBUG_SEQUENCE}\s.*$/
          debug_command
        elsif @command =~ /^#{DEBUG_SEQUENCE}$/
          debug_command
        else
          format_and_output
        end
      end
      
    private
      
      def exit
        Kernel.exit
      end
      
      def debug_command
        require "ruby-debug"
        debugger
        @command.gsub!("debug ", "")
        format_and_output
      end
      
      def format_and_output
        OutputFormatter.format(Guillotine.execute(@command))
      end
    end
  end
end
