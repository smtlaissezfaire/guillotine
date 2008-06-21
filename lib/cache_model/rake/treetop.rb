module Guillotine
  module RakeTasks
    class Treetop
      TREETOP_FILES = FileList['**/*.treetop']

      class << self
        def compile
          TREETOP_FILES.each { |f| sh "tt #{f}" }
        end
      end
    end
  end
end
