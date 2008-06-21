module CachedModel
  module RakeTasks
    # Build the TAGS file for Emacs
    # Taken with slight modifications from 
    # http://blog.lathi.net/articles/2007/11/07/navigating-your-projects-in-emacs
    #
    # Thanks Jim Weirich
    module Emacs
      module Tags
        RUBY_FILES = FileList['**/*.rb'].exclude("pkg")
      end
    end
  end
end
