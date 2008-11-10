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
          Kernel.exit
        elsif @command =~ /^#{DEBUG_SEQUENCE}\s.*$/
          require "ruby-debug"
          debugger
          OutputFormatter.format(Guillotine.execute(@command.gsub("debug ", "")))
        elsif @command =~ /^#{DEBUG_SEQUENCE}$/
          require "ruby-debug"
          debugger
          OutputFormatter.format(Guillotine.execute(@command.gsub("debug ", "")))
        else
          OutputFormatter.format(Guillotine.execute(@command))
        end
      end
    end
  end
end
