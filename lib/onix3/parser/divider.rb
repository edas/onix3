require 'cgi'

module Onix3
  module Parser
    class Divider < Base

      def each_product_document(extract=true)
        each_product(extract) do |product|
          if extract
            yield document_for_products([product])
          else
            yield
          end
        end
      end

      def start_document
        unless @document_started
          move_to_root
          prefix = reader.prefix
          attribs = root_attributes.to_a.map{ |a| " "+a[0]+"=\""+CGI.escapeHTML(a[1])+"\"" }.join('')
          tag = (prefix ? prefix+":" : "") + reader.tag("ONIXMessage")
          @opening = "<#{tag}#{attribs}>"
          move_to_header
          @header = reader.outer_xml
          @closing = "</#{tag}>"
        end
        @document_started = true
      end

      def each_product(extract=true)
        start_document
        count = 0
        while move_to_next_product
          count += 1
          if extract
            yield reader.outer_xml 
          else
            yield
          end
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
