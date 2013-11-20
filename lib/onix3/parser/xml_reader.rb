require 'nokogiri'

module Onix3
  module Parser
    
    class XmlReaderEofError < EOFError ; end

    class XmlReader < Nokogiri::XML::Reader
      
      ELEMENTS_TYPES = [TYPE_END_ELEMENT, TYPE_ELEMENT]
      TEXT_CONTENT_TYPES = [TYPE_CDATA, TYPE_TEXT, TYPE_SIGNIFICANT_WHITESPACE, TYPE_WHITESPACE]

      def eof?
        @eof
      end

      def self_if_not_eof
        eof? ? nil : self
      end

      def read
        @eof = ! super()
        return self_if_not_eof
      end

      def element?
        [TYPE_END_ELEMENT, TYPE_ELEMENT].include? node_type
      end

      def opening_element?
        node_type == TYPE_ELEMENT
      end

      def closing_element?
        node_type == TYPE_END_ELEMENT or (node_type == TYPE_ELEMENT and empty_element?)
      end

      def read!
        read or raise XmlReaderEofError, "End of XML source, nothing more to read"
      end

      def move_to_next_element
        begin ; read ; end until eof? or element?
        return self_if_not_eof
      end

      def move_to_opening
        return self_if_not_eof if opening_element?
        move_to_next_element until eof? or opening_element?
        return self_if_not_eof
      end

      def move_to_next_opening
        read if opening_element?
        move_to_opening
      end

      def move_to_first_child_element
        return nil if closing_element?
        move_to_next_element
        opening_element? ? self_if_not_eof : nil 
      end

      def move_to_first_child_element!
        move_to_first_child_element or raise "No child element"
      end

      def move_to_sibling_element
        move_to_closing
        move_to_next_element
        opening_element? ? self_if_not_eof : nil
      end

      def move_to_closing
        track = 0
        return self_if_not_eof if closing_element?
        until eof? or track < 0
          move_to_next_element
          track += 1 if opening_element?
          track -= 1 if closing_element?
        end
        return self_if_not_eof
      end

      def move_to_closing_parent
        move_to_closing 
        read
        move_to_closing
      end

      def move_to_parent_sibling_element
        move_to_closing_parent
        move_to_sibling_element
      end

      def element_is?(ns, ln)
        namespace_uri == ns and local_name == ln
      end

      def attribute_ns(local, uri)
        prefix = prefix_for_namespace_uri(uri)
        attribute("#{prefix}:#{local}")
      end

      def prefix_for_namespace_uri(uri)
        is_empty = false
        namespaces.each_pair {|xmlns,ns|
          if ns == uri
            if xmlns=="xmlns"
              is_empty = true 
            else
              return xmlns.gsub(/^xmlns:/, "")
            end
          end
        }
        return "" if is_empty
        raise "No xmlns prefix for #{uri}"
      end

      def is_on?(names, ns=nil)
        names = [names] unless names.is_a? Array
        names.each {|el| 
          el, ns = el[:namespace_uri], el[:local_name] if el.is_a? Hash
          return true if element_is? ns, el
        }
        return false
      end

      def is_on!(names, ns=nil)
        is_on?(names, ns) or raise "XML element #{namespace_uri} : #{local_name} not expected here"
      end

      def text_content_node?
        return ()
      end

      def read_text_content
        return nil if closing_element? or eof?
        content = ""
        until closing_element? or eof?
          read
          content << value if TEXT_CONTENT_TYPES.include? node_type
        end
        content.strip
      end

      def with_children
        raise "#{local_name} should be opening element, is not" unless opening_element?
        raise "#{local_name} should have child, has not" if empty_element?
        move_to_first_child_element 
        yield
        raise "#{local_name} should be closing element, is not" unless closing_element?
        raise "#{local_name} is empty element, should not" if empty_element?
        move_to_sibling_element
      end

      def get_then_sibling(names=nil)
        is_on!(names) if names
        data = read_text_content
        move_to_sibling_element
        return data
      end

    end
  end
end
