module Onix3
  module Model
    class Message
      attr_accessor :header
      attr_accessor :products
      def initialize
        @products = [ ]
      end
    end
  end
end
