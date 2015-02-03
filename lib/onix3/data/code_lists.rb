module Onix3
  module Data
    CodeLists = Hash.new do |hash,key|
      hash[key] = Loader.load_code_list(key)
    end
  end
end
