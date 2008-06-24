
require "rubygems"
require "set"
require "treetop"


project = File.dirname(__FILE__) + "/guillotine"

require "#{project}/require"
require "#{project}/extensions"

Guillotine.module_eval do
  autoload :Assertions,      		 			"#{project}/assertions"
  autoload :DataStore,       		 			"#{project}/data_store"
  autoload :PreParser,       		 			"#{project}/pre_parser"
  autoload :ConditionNode,   		 			"#{project}/condition_tree"
  autoload :ProperBinaryTree,		 			"#{project}/condition_tree"
  autoload :ConjunctionConditionNode, "#{project}/condition_tree"
  autoload :DisjunctionConditionNode, "#{project}/condition_tree"
  autoload :Keywords,         				"#{project}/keywords"
  autoload :Expression,       				"#{project}/expression"
  autoload :RakeTasks,        				"#{project}/rake"
end

require "#{project}/parser"
