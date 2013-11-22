module Onix3
  module Parser
    class Base

      attr_writer :reader

      def initialize(io)
        io.binmode
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
          @is_short_tags = false
        elsif reader.local_name == "ONIXmessage"
          @is_short_tags = true
        else
          raise "ONIX3 XML message root is not <ONIXMessage> or <ONIXmessage>"
        end
        @onix_version = @reader.attribute("version")
      end

    end
  end
end
