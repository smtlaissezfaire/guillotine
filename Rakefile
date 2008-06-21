
require File.dirname(__FILE__) + "/lib/cache_model"
TASKS = CachedModel::RakeTasks

namespace "tags" do
  task :emacs => TASKS::Emacs::Tags::RUBY_FILES do
    puts "Making Emacs TAGS file"
    sh "ctags -e #{TASKS::Emacs::Tags::RUBY_FILES}", :verbose => false
  end
end

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]


