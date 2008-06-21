
require File.dirname(__FILE__) + "/lib/cache_model"
TASKS = CachedModel::RakeTasks

namespace "tags" do
  ruby_files = TASKS::Emacs::Tags::RUBY_FILES
  
  task :emacs => ruby_files do
    puts "Making Emacs TAGS file"
    sh "ctags -e #{ruby_files}", :verbose => false
  end
end

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]


