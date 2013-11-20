module Onix3
  module Data
    class CodeList < Hash

      attr_accessor :number
      attr_accessor :description
      attr_accessor :issue_number

      def to_i
        number.to_i
      end

    end
  end
end
