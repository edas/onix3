# Onix3

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'onix3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install onix3

## Usage

### Executable

`onix3 comment onixfile.xml` returns the onix file commented (code and lists descriptions as xml comments)

`onix3 extract onixfile.xml 3325246` returns the onix file (with headers) leaving only the products that matche the identifier 332546 (this is a simple plain text match, which validates the product even if the identifier is found in ProductParts or RelatedProducts)

`onix3 extract onixfile.xml 3325246 --comment` does the same as above but commenting the product extracted.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
