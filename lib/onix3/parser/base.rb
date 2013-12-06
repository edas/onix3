require 'cgi'

module Onix3
  module Parser
    class Base

      attr_writer :reader

      def initialize(io)
        io.binmode if io.respond_to? :binmode
        @io = io
      end

      def reader
        @reader ||= OnixReader.from_io(@io)
      end

      def move_to_root
        reader.move_to_next_opening
        analyze_root
      end

      def move_to_header
        reader.move_to_first_child_element
      end

      def move_to_next_product
        reader.move_to_sibling_element
        reader.move_to_sibling_element until reader.eof? or reader.is_on?("Product")
        reader.is_on?("Product") and not reader.eof?
      end

      def analyze_root
        if reader.local_name == "ONIXMessage"
          reader.short_tags = false
        elsif reader.local_name == "ONIXmessage"
          reader.short_tags = true
        else
          raise "ONIX3 XML message root is not <ONIXMessage> or <ONIXmessage>"
        end
        reader.onix3_namespace = reader.namespace_uri
        @onix_version = @reader.attribute("version")
      end

      def root_attributes
        # We should use reader.attributes, but it seems that
        # if we use that, Nokogiri try to parse the whole document
        # same thing for reader.namespaces, reader.attribute_nodes
        # Doing so we ignore all non-standard attribute on root element
        attributes = { }
        if xmlns = reader.attribute("xmlns")
          attributes["xmlns"] = xmlns 
        end
        if release = reader.attribute("release")
          attributes["release"] = release 
        end
        if prefix = reader.prefix
          if prefixns = reader.attribute("xmlns:#{prefix}")
            attributes["xmlns:#{prefix}"] = prefixns
          end
        end
        attributes
      end

      def onix3_namespace
        @onix3_namespace
      end

    end
  end
end
