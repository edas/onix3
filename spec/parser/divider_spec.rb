require 'spec_helper'
require 'zlib'
describe Onix3::Parser::Divider do
  
  describe "#each_single_document" do

    before(:each) do
      @filename = "parser_divider-each_single_product-should_return_the_number_of_products.onix.xml.gz"
      @filepath = File.join(File.dirname(__FILE__), "..", "fixtures", @filename)
      @onix = Zlib::GzipReader.open(@filepath)
    end

    after(:each) do
      @onix.close if @onix
    end

    it "should return the number of products" do
      d = Onix3::Parser::Divider.new(@onix)
      res = d.each_single_document do |doc|
        # nothing
      end
      count = 0
      index = -1
      f = Zlib::GzipReader.open(@filepath)
      content = f.read
      f.close
      while index=content.index("<Product>",index+1)
        count += 1
      end
      expect(count).to be > 1
      expect(res).to eq(count)
    end

    it "should copy the exact header" do
      pending
    end

    it "should allow a namespace for the root tag" do
      pending
    end

    it "should copy the exact product" do
      pending
    end

    it "should yield valid xml" do
      pending
    end

  end

end
