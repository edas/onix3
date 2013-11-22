require 'yaml'

module Onix3
  module Data
    class Loader

      ENCODING = "UTF-8"

      include Onix3::Tools::Path

      def tags
        @tags ||= load_tags
      end

      def load_tags
        YAML.load( File.read(tags_filename, nil, nil, ENCODING) )
      end

      def short_tag_for(name)
        tags[name]
      end

      def code_list(number)
        @code_lists ||= { }
        @code_lists[number.to_s] ||= load_code_list(number)
      end

      def tags_filename
        @tags_filename || File.join(data_path, 'tags.yml')
      end

      def code_list_filename(number)
        File.join(code_lists_path, "list_#{number.to_s.rjust(3,'0')}.yml")
      end

      def load_code_list(number)
        list = CodeList.new
        data = YAML.load( File.read(code_list_filename(number), nil, nil, encoding: ENCODING ) )
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

      def code_list_numbers
        @code_list_numbers ||= YAML.load( File.read(lists_filename, nil, nil, encoding: ENCODING) )
      end

      def lists_filename
        @lists_filename || File.join(data_path, 'lists.yml')
      end

      def code_list_for_tag(name)
        if number = code_list_numbers[:tags][name]
          code_list(number)
        else
          nil
        end
      end



    end
  end
end
