module Onix3
  module Model
    class StringWithLanguage < String
      include Helper::CodeList

      attr_from_list :language, 74
    end
  end
end
