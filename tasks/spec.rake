require File.dirname(__FILE__) + "/../lib/guillotine"
TASKS = Guillotine::RakeTasks

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
