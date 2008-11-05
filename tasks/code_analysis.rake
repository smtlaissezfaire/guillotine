namespace :code_analysis do
  desc "Run roodi on the project"
  task :roodi do
    files = FileList.new("lib/**/*.rb").to_s
    sh "roodi #{files}"
  end
  
  desc "Flog the code"
  task :flog do
    files = FileList.new("lib/**/*.rb").to_s
    sh "flog #{files}"
  end
end
