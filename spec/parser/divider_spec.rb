require 'spec_helper'
require 'zlib'
require 'stringio'
require 'nokogiri'

describe Onix3::Parser::Divider do
  
  let(:simple_onix) {
    '<?xml version="1.0" encoding="UTF-8"?>' +
    '<ONIXMessage release="3.0" xmlns="http://www.editeur.org/onix/3.0/reference">' +
    '<Header>H</Header>' +
    '<Product>P</Product>' +
    '<Product>P</Product>' +
    '</ONIXMessage>'
  }

  let(:simple_onix_ns) {
    '<?xml version="1.0" encoding="UTF-8"?>' +
    '<onix:ONIXMessage release="3.0" xmlns:onix="http://www.editeur.org/onix/3.0/reference">' +
    '<onix:Header>H</onix:Header>' +
    '<onix:Product>P</onix:Product>' +
    '<onix:Product>P</onix:Product>' +
    '</onix:ONIXMessage>'
  }

  describe "#document_for_products" do

    it "should have ONIXMessage as root" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      doc = d.document_for_products([])
      expect(doc).to match(/<\w+/)
      expect(doc.match(/<\w+/)[0]).to eq("<ONIXMessage")
    end

    it "should have header" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      doc = d.document_for_products([])
      expect(doc).to match(/<Header[^>]*>H<\/Header>/)
    end

    it "should yield valid xml" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      doc = d.document_for_products([])
      p = Nokogiri.XML(doc) { |config| config.nonet }
      expect(p).to be_true
    end

    it "should contain products" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      doc = d.document_for_products(["<Product>1</Product>", "<Product>2</Product>"])
      expect(doc).to match(/<Product>1<\/Product>/)
      expect(doc).to match(/<Product>2<\/Product>/)
    end      

  end

  describe "#document_end" do

    it "should close ONIXMessage tag" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      expect(d.document_end).to eq("</ONIXMessage>")
    end

  end

  describe "#document_start" do

    it "should have ONIXMessage as root" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      start = d.document_start
      expect(start).to match(/<\w+/)
      expect(start.match(/<\w+/)[0]).to eq("<ONIXMessage")
    end

    it "should have header" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      start = d.document_start
      expect(start).to match(/<Header[^>]*>H<\/Header>/)
    end

    it "should yield valid xml" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      start = d.document_start
      p = Nokogiri.XML(start + d.document_end) { |config| config.nonet }
      expect(p).to be_true
    end

  end

  describe "#each_product" do

    it "should return the number of products" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      res = d.each_product do |doc|
        # nothing
      end
      expect(res).to eq(2)
    end

    it "should copy the exact product" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      d.each_product_document do |doc|
        expect(doc).to match(/<Product[^>]*>P<\/Product>/)
      end
    end

  end

  describe "#each_product_document" do    

    it "should return the number of products" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      res = d.each_product_document do |doc|
        # nothing
      end
      expect(res).to eq(2)
    end

    it "should copy the exact header" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      res = d.each_product_document do |doc|
        expect(doc).to match(/<Header[^>]*>H<\/Header>/)
      end
    end

    it "should allow a namespace for the root tag" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix_ns))
      res = d.each_product_document do |doc|
        expect(doc.index(">H</")).to be > 0
      end
    end

    it "should allow a namespaced attribute for the root tag" do
      pending "Nokogiri issue 843" # https://github.com/sparklemotion/nokogiri/issues/843
    end

    it "should copy the exact product" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      d.each_product_document do |doc|
        expect(doc).to match(/<Product[^>]*>P<\/Product>/)
      end
    end

    it "should yield valid xml" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      d.each_product_document do |doc|
        p = Nokogiri.XML(doc) { |config| config.nonet }
        expect(p).to be_true
      end
    end

  end

end
