module Onix3
  module Parser
    class OnixReader < XmlReader
      
      ONIX3_NAMESPACE = "http://www.editeur.org/onix/3.0/reference"

      def is_on?(names, ns=ONIX3_NAMESPACE)
        if ns==ONIX3_NAMESPACE
          names = tag(names) if names.kind_of? String
        else
          names.map{ |name| tag(name) }.flatten if names.kind_of? Array
        end
        super(names, ns)
      end

      def assert_on!(names, ns=ONIX3_NAMESPACE)
        if ns==ONIX3_NAMESPACE
          names = tag(names) if names.kind_of? String
        else
          names.map{ |name| tag(name) }.flatten if names.kind_of? Array
        end
        super(names, ns)
      end

      def tag(name)
        short_tags? ? short_tag_for(name) : name
      end

      def tags(name)
        if short_tags.nil?
          [name, short_tag_for(name)]
        else
          [tag(name)]
        end
      end

      def short_tags?
        return @short_tags
      end

      def short_tag_for(name)
        data.short_tags.fetch(name)
      end

      def data
        @data ||= Onix3::Data::Loader.new
      end

    end
  end
end
