
require "rubygems"
require "set"
require "treetop"


project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"
require "#{project}/parser"

Guillotine.module_eval do
  autoload :Assertions,       "#{project}/assertions"
  autoload :PreParser,        "#{project}/pre_parser"
  autoload :ConditionNode,    "#{project}/condition_tree"
  autoload :Keywords,         "#{project}/keywords"
  autoload :Expression,       "#{project}/expression"
  autoload :SelectExpression, "#{project}/select_expression"
  autoload :RakeTasks,        "#{project}/rake"
end

