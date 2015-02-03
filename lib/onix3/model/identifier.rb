module Onix3
  module Model
    class Identifier
      include Helper::CodeList
      include Helper::StringWithLanguage

      attr_from_list :type, 44
      attr_with_language :name
      attr_accessor :value

      def initialize(type,value,name=nil,language=nil)
        self.type= type
        self.value = value
        self.name = StringWithLanguage.new(name, language) if name
      end

    end
  end
end
