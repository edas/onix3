require "onix3/version"
require "onix3/tools/path.rb"
require "onix3/data/code.rb"
require "onix3/data/code_list.rb"
require "onix3/data/loader.rb"
require "onix3/parser/xml_reader.rb"
require "onix3/parser/onix_reader.rb"
require "onix3/parser/base.rb"
require "onix3/parser/divider.rb"
require "onix3/tools/code_list_updater.rb"
require "onix3/tools/commenter.rb"

module Onix3
  
  @@data_path = nil
  
  def self.data_path=(data_path)
    @@data_path = data_path 
  end

  def self.data_path
    @@data_path || File.join(File.dirname(__FILE__),"onix3","data")
  end

end
