
# TODO: spec this load error
# begin
  require "facets/indexable"
# rescue LoadError
#   raise LoadError, "You need to install the facets gem (sudo gem install facets)"
# end

require File.dirname(__FILE__) + "/extensions/object"
require File.dirname(__FILE__) + "/extensions/string"
