require 'nokogiri'
require 'yaml'


module Onix3
  module Tools
    class CodeListUpdater
      
      ENCODING = "UTF-8"

      include Onix3::Tools::Path

      def update_with(code_list_file)
        doc = Nokogiri::Slop File.read(code_list_file, nil, nil, encoding: ENCODING)
        doc.ONIXCodeTable.CodeList.each do |list|
          update_code_list(xml)
        end
      end

      def update_code_list(xml)
        list_number = list.CodeListNumber.content
        l = list_content(list_number)
        l[:description] = list.CodeListDescription.content
        l[:issue_number] = list.IssueNumber.content
        l[:number] = list_number
        l[:codes] ||= { }
        begin
          list.Code.each do |code|
            update_code_in_list(code, l)
          end
        rescue
          # nothing
        end
        File.write(list_filename, YAML.dump(l), 0, encoding: ENCODING)
      end

      def update_code_in_list(xml, list)
        value = code.CodeValue.content
        l[:codes][value] = {
          value: value,
          description: xml.CodeDescription.content,
          notes: xml.CodeNotes.content,
          issue_number: xml.IssueNumber.content
        }
      end

      def list_filename(number)
        File.join(lists_dir, "list_#{number.rjust(3,'0')}.yml")
      end

      def list_content(number)
        list_filename = self.list_filename(list_number)
        File.exists?(list_filename) ? YAML.load( File.read(list_filename, nil, nil, encoding: ENCODING) ) : { number: list_number }
      end

    end

  end
end
