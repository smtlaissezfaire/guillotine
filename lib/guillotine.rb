
require "rubygems"
require "set"

guillotine = File.dirname(__FILE__) + "/guillotine"

require "#{guillotine}/extensions"
require "#{guillotine}/treetop"

Guillotine.module_eval do
  autoload :Assertions,       "#{guillotine}/assertions"
  autoload :PreParser,        "#{guillotine}/pre_parser"
  autoload :ConditionNode,    "#{guillotine}/condition_tree"
  autoload :Keywords,         "#{guillotine}/keywords"
  autoload :Expression,       "#{guillotine}/expression"
  autoload :SelectExpression, "#{guillotine}/select_expression"
  autoload :RakeTasks,        "#{guillotine}/rake"
end

