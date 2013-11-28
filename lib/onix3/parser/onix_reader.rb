module Onix3
  module Parser
    class OnixReader < XmlReader
      
      ONIX3_NAMESPACE = "http://www.editeur.org/onix/3.0/reference"
      ONIX3_SHORT_NAMESPACE = "http://ns.editeur.org/onix/3.0/short"

      def is_on?(names, ns=onix3_namespace)
        if ns==onix3_namespace
          names = tag(names) if names.kind_of? String
        else
          names.map{ |name| tag(name) }.flatten if names.kind_of? Array
        end
        super(names, ns)
      end

      def assert_on!(names, ns=onix3_namespace)
        if ns==onix3_namespace
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

      def short_tags=(bool)
        @short_tags = bool
      end

      def short_tag_for(name)
        data.short_tags.fetch(name)
      end

      def data
        @data ||= Onix3::Data::Loader.new
      end

      def onix3_namespace
        if @onix3_namespace.nil?
          short_tags? ? ONIX3_SHORT_NAMESPACE : ONIX3_NAMESPACE
        else
          @onix3_namespace || nil
        end
      end 

      def onix3_namespace=(ns)
        ns = false if ns.nil?
        @onix3_namespace = ns
      end

    end
  end
end
