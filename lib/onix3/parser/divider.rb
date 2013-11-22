require 'cgi'

module Onix3
  module Parser
    class Divider < Base

      def each_product_document
        each_product do |product|
          yield document_for_products([product])
        end
      end

      def start_document
        unless @document_started
          move_to_root
          prefix = reader.prefix
          attribs = reader.attributes.to_a.map{ |a| " "+a[0]+"=\""+CGI.escapeHTML(a[1])+"\"" }.join('')
          tag = (prefix ? prefix+":" : "") + reader.tag("ONIXMessage")
          @opening = "<#{tag}#{attribs}>"
          move_to_header
          @header = reader.outer_xml
          @closing = "</#{tag}>"
        end
        @document_started = true
      end

      def each_product
        start_document
        count = 0
        while move_to_next_product
          count += 1
          yield( reader.outer_xml )
        end
        count
      end

      def document_for_products(products)
        "#{document_start}#{products.join("\n")}\n#{document_end}"
      end

      def document_start
        start_document
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n#{@opening}\n#{@header}\n"
      end

      def document_end
        start_document
        @closing
      end


    end
  end
end
