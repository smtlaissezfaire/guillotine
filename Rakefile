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

namespace "tags" do
  task :emacs => Emacs::Tags::RUBY_FILES do
    puts "Making Emacs TAGS file"
    sh "ctags -e #{Emacs::Tags::RUBY_FILES}", :verbose => false
  end
end

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]
