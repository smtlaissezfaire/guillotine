
require File.dirname(__FILE__) + "/lib/guillotine"
TASKS = Guillotine::RakeTasks

namespace :tags do
  ruby_files = TASKS::Emacs::Tags::RUBY_FILES
  
  task :emacs => ruby_files do
    puts "Making Emacs TAGS file"
    sh "ctags -e #{ruby_files}", :verbose => false
  end
end

namespace :treetop do
  task :compile do
    TASKS::Treetop.compile
  end
end

namespace :spec do
  Spec::Rake::SpecTask.new(:examples) do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ["--diff", "--color", "--reverse", "--format", "profile"]
  end
end


desc "Run all specs"
task :spec => ["spec:examples"]

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]

desc "Recompile the treetop files"
task :treetop => ["treetop:compile"]

