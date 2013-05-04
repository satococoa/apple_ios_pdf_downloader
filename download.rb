require 'bundler/setup'
require 'pathname'
require 'uri'
require 'open-uri'
require 'pp'
Bundler.require

page_url = 'https://developer.apple.com/jp/devcenter/ios/library/japanese.html'
page_uri = URI.parse(page_url)
output_directory = './out'
output_path = Pathname(output_directory)

output_path.mkdir unless output_path.exist?
document = Nokogiri::HTML(open(page_url).read)

contents = []

document.search('a[href$="pdf"]').each do |link|
  title = link.text
  url = page_uri + link[:href]
  contents << {title: title, url: url}
end

Curl::Multi.download(contents.map{|c| c[:url].to_s}, {}, {},
  contents.map{|c| (output_path+c[:title].gsub(%r!(\s|/)!, '')).to_s + '.pdf'}
  ) do |c, path|
  puts "#{path} finished!"
end
