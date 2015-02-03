require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'onix3'

Dir[File.join(File.dirname(__FILE__),"support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # some (optional) config here
  config.color = true
  config.formatter     = 'documentation'
end
