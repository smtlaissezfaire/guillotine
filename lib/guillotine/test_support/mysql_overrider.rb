module Guillotine
  module TestSupport
    class MysqlOverrider
      def initialize(db_connection, guillotine_connection)
        @db_connection = db_connection
        @guillotine_connection = guillotine_connection
        redefine_methods!
      end
      
      attr_reader :db_connection
      attr_reader :guillotine_connection
      
      def select_from_db(sql, message=nil)
        db_connection.instance_eval do
          select_aliased_from_guillotine(sql, message)
        end
      end
      
      def select_from_guillotine(sql, message=nil)
        guillotine_connection.select(sql).map { |hash| hash.stringify_keys }
      end
      
      def insert_sql_from_guillotine(*args)
        guillotine_connection.insert_sql(args.first)
      end
      
    private
      
      def redefine_methods!
        overrider = self
        
        metaclass = class << @db_connection; self; end
        
        [:select, :insert_sql].each do |method_name|
          metaclass.instance_eval do
            new_method_name = "#{method_name}_aliased_from_guillotine".to_sym
            
            alias_method new_method_name, method_name
            define_method method_name do |*args|
              overrider.__send__("#{method_name}_from_guillotine", *args)
            end
          end
        end
      end
    end
  end
end
