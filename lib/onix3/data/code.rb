module Onix3
  module Data
    class Code < Hash

      def value
        fetch(:value)
      end

      def description
        fetch(:description)
      end

      def notes
        fetch(:notes)
      end

      def issue_number
        fetch(:issue_number)
      end

      def to_s
        value
      end

    end
  end
end
