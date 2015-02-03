module Onix3
  module Model
    class Sender
      attr_accessor :identifiers
      attr_accessor :name
      def initialize
        @identifiers = [ ]
      end
    end
  end
end
