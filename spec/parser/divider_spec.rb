require 'spec_helper'
require 'zlib'
require 'stringio'
require 'nokogiri'

describe Onix3::Parser::Divider do
  
  describe "#each_single_document" do

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

    it "should return the number of products" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      res = d.each_single_document do |doc|
        # nothing
      end
      expect(res).to eq(2)
    end

    it "should copy the exact header" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      res = d.each_single_document do |doc|
        expect(doc.index(">H</Header>")).to be > 0
      end
    end

    it "should allow a namespace for the root tag" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix_ns))
      res = d.each_single_document do |doc|
        expect(doc.index(">H</")).to be > 0
      end
    end

    it "should allow a namespaced attribute for the root tag" do
      pending "Nokogiri issue 843" # https://github.com/sparklemotion/nokogiri/issues/843
    end

    it "should copy the exact product" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      d.each_single_document do |doc|
        expect(doc.index(">P</Product>")).to be > 0
      end
    end

    it "should yield valid xml" do
      d = Onix3::Parser::Divider.new(StringIO.new(simple_onix))
      d.each_single_document do |doc|
        p = Nokogiri.XML(doc) { |config| config.nonet }
        expect(p).to be_true
      end
    end

  end

end
