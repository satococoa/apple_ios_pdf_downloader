require 'bundler/setup'
Bundler.require
PAGE_URI = 'https://developer.apple.com/jp/devcenter/ios/library/japanese.html'

document = Nokogiri::HTML(HTTPClient.get(PAGE_URI).body)
p document