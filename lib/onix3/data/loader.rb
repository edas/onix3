require 'yaml'

module Onix3
  module Data
    class Loader

      def short_tags
        @short_tags ||= load_short_tags
      end

      def load_short_tags
        YAML.load( File.read(short_tags_filename) )
      end

      def short_tag_for(name)
        short_tags[name]
      end

      def code_list(number)
        @code_lists ||= { }
        @code_lists[number.to_s] ||= load_code_list(number)
      end

      def short_tags_filename
        @short_tags_filename || File.join(data_path, 'tags.yml')
      end

      def data_path
        @data_path || File.dirname(__FILE__)
      end

      def code_list_filename(number)
        File.join(code_lists_path, "list_#{number.to_s.rjust(3,'0')}.yml")
      end

      def load_code_list(number)
        list = CodeList.new
        data = YAML.load( File.read(code_list_filename(number) ) )
        list.number = data[:number]
        list.description = data[:description]
        list.issue_number = data[:issue_number]
        data[:codes].each_pair do |key,value|
          c = Code.new
          value.each_pair do |ckey,cvalue|
            c[ckey] = cvalue
          end
          list[key] = c
        end
        list
      end

    end
  end
end
