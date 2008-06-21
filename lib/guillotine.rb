
require "rubygems"
require "set"

module Guillotine; end

require File.dirname(__FILE__) + "/guillotine/assertions"
require File.dirname(__FILE__) + "/guillotine/pre_parser"
require File.dirname(__FILE__) + "/guillotine/extensions"
require File.dirname(__FILE__) + "/guillotine/condition_tree"
require File.dirname(__FILE__) + "/guillotine/keywords"
require File.dirname(__FILE__) + "/guillotine/expression"
require File.dirname(__FILE__) + "/guillotine/treetop"
require File.dirname(__FILE__) + "/guillotine/select_expression"

Guillotine.autoload :RakeTasks, File.dirname(__FILE__) + "/guillotine/rake"
