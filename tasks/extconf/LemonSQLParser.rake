namespace :extconf do

  GRAMMAR_NAME   = "parser"
  TOKENIZER_NAME = "tokenizer"

  extension = File.basename(__FILE__, '.rake')

  ext = "ext/#{extension}"
  ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
  ext_files = FileList[
    "#{ext}/*.c",
    "#{ext}/*.h",
    "#{ext}/*.rl",
    "#{ext}/*.y",
    "#{ext}/extconf.rb",
    "#{ext}/Makefile"
  ]

  task :compile => [:compile_grammar, :compile_ragel, extension] do
    if Dir.glob("**/#{extension}.{o,so,dll}").length == 0
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      STDERR.puts "Gem actually failed to build.  Your system is"
      STDERR.puts "NOT configured properly to build #{GEM_NAME}."
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      exit(1)
    end
  end

  task :compile_grammar do
    sh "lemon #{ext}/#{GRAMMAR_NAME}.y"
  end

  task :compile_ragel do
    sh "ragel #{ext}/#{TOKENIZER_NAME}.rl"
  end

  desc "Builds just the #{extension} extension"
  task extension.to_sym => [:make_clean, "#{ext}/Makefile", ext_so ]

  task :make_clean do
    sh "cd #{ext}; make clean"
  end

  file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
    Dir.chdir(ext) do 
      ruby "extconf.rb"
    end
  end

  file ext_so => ext_files do
    Dir.chdir(ext) do
      sh(PLATFORM =~ /win32/ ? 'nmake' : 'make') do |ok, res|
        if !ok
          require "fileutils"
          FileUtils.rm Dir.glob('*.{so,o,dll,bundle}')
        end
      end
    end
  end
end
