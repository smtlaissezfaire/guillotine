require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

desc "Verify the sanity of the project (run rake spec and verify rcov report)"
task :test => ["spec:rcov", "spec:verify_rcov"]

desc "Build the project"
task :build => [:treetop, :tags, :test]

task :default => :spec
