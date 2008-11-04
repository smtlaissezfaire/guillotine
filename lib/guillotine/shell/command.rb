module Guillotine
  module Shell
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
  end
end
