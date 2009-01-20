namespace :treetop do
  task :compile do
    TASKS::Treetop.compile
  end
end

desc "Recompile the treetop files"
task :treetop => ["treetop:compile"]

task :tt => :treetop
