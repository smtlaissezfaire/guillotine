require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

desc "Verify the sanity of the project (run rake spec and verify rcov report)"
task :test => ["spec:rcov", "spec:verify_rcov"]

desc "Build the project - Compiling the C extension, generating the treetop .rb files, and running the 'tests'"
task :build => ["extconf:compile", :treetop, :tags, :test]

# Make sure compilation of the C extension occurs *before* running the specs
task(:spec).insert_dependency "extconf:compile"

task :default => :spec
