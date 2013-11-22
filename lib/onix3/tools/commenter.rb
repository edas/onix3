module Onix3
  module Tools
    class Commenter

      def data
        @loader ||= Onix3::Data::Loader.new
      end

      def keys
        data.code_list_numbers[:tags].keys
      end

      def search_re
        unless @search_re
          union = Regexp.union(*keys)
          @search_re = Regexp.new("([ \t\n\r]*)<#{union}[^>]*>\s*([a-zA-Z0-9]+)\s*</(#{union})>")
        end
        @search_re
      end

      def comment(io)
        io.read.gsub(search_re) do |match|
          cl = nil
          v = nil
          begin
            cl = data.code_list_for_tag($3)
            v = cl ? cl.fetch($2) : nil
          rescue Exception => e
            puts "No code for #{$3} #{$2} ?"
            raise e
          end
          cl_intro = "#{$1}<!-- <#{$3}> : list ##{cl.number} \"#{cl.description}\" -->"
          cl_val = "#{$1}<!-- code ##{$2} \"#{v[:description]}\" : #{v[:notes]} -->"
          match + cl_intro + cl_val
        end
      end

      def comment_file(file)
        File.open(file, "r") do |io|
          comment(io)
        end
      end

    end
  end
end
