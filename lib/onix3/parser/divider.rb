require 'cgi'

module Onix3
  module Parser
    class Divider < Base

      def each_product_document
        each_product do |product|
          yield document_for_products([product])
        end
      end

      def each_product
        move_to_root
        prefix = reader.prefix
        attribs = reader.attributes.to_a.map{ |a| " "+a[0]+"=\""+CGI.escapeHTML(a[1])+"\"" }.join('')
        tag = (prefix ? prefix+":" : "") + reader.tag("ONIXMessage")
        @opening = "<#{tag}#{attribs}>"
        move_to_header
        @header = reader.outer_xml
        @closing = "</#{tag}>"
        count = 0
        while move_to_next_product
          count += 1
          yield( reader.outer_xml )
        end
        count
      end

      def document_for_products(products)
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n#{@opening}\n#{@header}\n#{products.join("\n")}\n#{@closing}"
      end

    end
  end
end
