filename = ARGV[0]
lists_dir = ARGV[1]

require 'nokogiri'
require 'yaml'

doc = Nokogiri::Slop File.read(filename)

doc.ONIXCodeTable.CodeList.each do |list|

  list_number = list.CodeListNumber.content
  list_filename = File.join(lists_dir, "list_#{list_number.rjust(3,'0')}.yml")
  l = File.exists?(list_filename) ? YAML.load( File.read(list_filename) ) : { number: list_number }
  l[:description] = list.CodeListDescription.content
  l[:issue_number] = list.IssueNumber.content
  l[:number] = list_number
  l[:codes] ||= { }
  begin
    list.Code.each do |code|
      value = code.CodeValue.content
      l[:codes][value] = {
        value: value,
        description: code.CodeDescription.content,
        notes: code.CodeNotes.content,
        issue_number: code.IssueNumber.content
      }
    end
  rescue
    # nothing
  end
  File.write(list_filename, YAML.dump(l))

end
