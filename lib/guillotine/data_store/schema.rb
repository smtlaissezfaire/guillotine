module Guillotine
  module DataStore
    class Schema
      def initialize
        @columns = []
      end

      attr_accessor :table, :columns

      def primary_key
        columns.detect { |column| column.primary_key? }
      end

      def primary_key?
        primary_key ? true : false
      end

      def auto_incrementing?
        primary_key? ? primary_key.auto_incrementing? : false
      end
    end
  end
end
