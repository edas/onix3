module Onix3
  module Tools
    module Path

      attr_writer :data_path
      attr_writer :code_lists_path

      def data_path
        @data_path || Onix3.data_path
      end

      def code_lists_path
        @code_lists_path || File.join(data_path, "lists")
      end

    end
  end
end
