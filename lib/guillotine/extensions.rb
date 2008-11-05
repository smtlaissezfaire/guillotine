
# TODO: spec this load error
# begin
  require "facets/indexable"
# rescue LoadError
#   raise LoadError, "You need to install the facets gem (sudo gem install facets)"
# end

dir = File.dirname(__FILE__)
require "#{dir}/extensions/string"
require "#{dir}/extensions/symbol"
require "#{dir}/extensions/fixnum"
