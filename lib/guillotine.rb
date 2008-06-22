
require "rubygems"
require "set"

module Guillotine; end

require File.dirname(__FILE__) + "/guillotine/extensions"
Guillotine.autoload :Assertions,     File.dirname(__FILE__) + "/guillotine/assertions"
Guillotine.autoload :PreParser,      File.dirname(__FILE__) + "/guillotine/pre_parser"
Guillotine.autoload :ConditionNode,  File.dirname(__FILE__) + "/guillotine/condition_tree"
Guillotine.autoload :Keywords,  File.dirname(__FILE__) + "/guillotine/keywords"
Guillotine.autoload :Expression, File.dirname(__FILE__) + "/guillotine/expression"
require File.dirname(__FILE__) + "/guillotine/treetop"
Guillotine.autoload :SelectExpression, File.dirname(__FILE__) + "/guillotine/select_expression"
Guillotine.autoload :RakeTasks, File.dirname(__FILE__) + "/guillotine/rake"
