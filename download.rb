require 'bundler/setup'
require 'pathname'
require 'uri'
Bundler.require

page_url = 'https://developer.apple.com/jp/devcenter/ios/library/japanese.html'
page_uri = URI.parse(page_url)
output_directory = './out'
output_path = Pathname(output_directory)

output_path.mkdir unless output_path.exist?
document = Nokogiri::HTML(HTTPClient.get(page_url).body)

document.search('a[href$="pdf"]').each do |link|
  title = link.text
  url = page_uri + link[:href]

  puts "\e[32m===== downloading [#{title}](#{url}) =====\e[0m"

  file = (output_path + title).to_s.gsub(/\s/, '') + '.pdf'
  open(file, 'wb') {|f|
    f.puts HTTPClient.get(url).body
  }
end