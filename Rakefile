
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
  
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.rcov = true
    t.spec_files = FileList['spec/**/*.rb']
    t.rcov_dir   = "doc/coverage"
    t.rcov_opts  = ["--exclude", "rcov,rspec,facets,polyglot,gems.*treetop,spec,parser\/.+\.rb"]
  end
  
  RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
    t.threshold = 100.0 # Make sure you have rcov 0.7 or higher!
    t.index_html = 'doc/coverage/index.html'
  end
end


desc "Run all specs"
task :spec => ["spec:examples"]

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]

desc "Recompile the treetop files"
task :treetop => ["treetop:compile"]

desc "Verify the sanity of the project (run rake spec and verify rcov report)"
task :test => ["spec:rcov", "spec:verify_rcov"]

desc "Build the project"
task :build => [:treetop, :tags, :test]
