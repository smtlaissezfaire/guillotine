require 'fileutils'
include FileUtils

# Install the MySQL driver:
#   gem install mysql
#
# On Mac OS X:
#   sudo gem install mysql -- --with-mysql-dir=/usr/local/mysql
#
#   Or, try the following if you are experiencing compile errors
#
#     sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config
#
# On Mac OS X, with MacPorts / DarwinPorts
#
# 	sudo gem install mysql -- --with-mysql-include=/opt/local/include/mysql5  \
# 		--with-mysql-lib=/opt/local/lib/mysql5 	\
# 		--with-mysql-config=/opt/local/lib/mysql5/bin/mysql_config
#
# On Mac OS X Leopard:
#
#   sudo env ARCHFLAGS="-arch i386" gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config
#       This sets the ARCHFLAGS environment variable to your native architecture
#
# On Windows:
#
#   gem install mysql
#       Choose the win32 build.
#       Install MySQL and put its /bin directory on your path.
#
# And be sure to use new-style password hashing:
#   http://dev.mysql.com/doc/refman/5.0/en/old-client.html

REQUIRED_GEMS = [
  "rake",
  "hoe",
  "newgem",
  "facets",
  {
    :name => "rspec",
    :require => "spec"
  },
  "rcov",
  "active_record",
  "mysql",
  "treetop",
  {
    :name => "diff-lcs",
    :require => "diff/lcs"
  }
]

require 'rubygems'
REQUIRED_GEMS.each do |req_gem|
  if req_gem.is_a?(Hash)
    gem_name = req_gem[:name]
    require_name = req_gem[:require]
  else
    gem_name = require_name = req_gem
  end
  
  begin
    require(require_name)
  rescue LoadError
    puts "This Rakefile requires the '#{gem_name}' RubyGem."
    puts "Installation: gem install #{gem_name} -y"
    exit
  end
end

$:.unshift(File.join(File.dirname(__FILE__), %w[.. lib]))
