module Guillotine
  module DataStore
    dir = File.dirname(__FILE__) + "/data_store"
    autoload :Schema, "#{dir}/schema"
    autoload :Table,  "#{dir}/table"

    require "#{dir}/database"
    extend DataStore::Database

    class UnknownTable < StandardError; end
    class TableAlreadyExists < StandardError; end
  end
end
