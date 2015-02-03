module Onix3
  module Model
    class CodeFromList

      attr_accessor :code
      attr_accessor :list_number
      
      def initialize(code, list_number)
        @code = code
        @list_number = list_number
      end

      def respond_to?(:name, include_all=false)
        super(name, include_all) or list_value.respond_to?(name, include_all)
      end

      def list_value
        list[@code]
      end
      
      def list
        Data::CodeLists[@list_number]
      end

    end
  end
end
