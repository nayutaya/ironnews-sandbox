#! ruby -Ku

require "rubygems"
require "nokogiri"

doc = File.open("dump.xml", "rb") { |file| Nokogiri(file) }

outfile = File.open("url_tag.txt", "wb")

items = doc.xpath("//entry").map { |item|
  url   = item.xpath("link[@rel='related']").attribute("href").text
  tags  = item.xpath("subject").map { |tag| tag.text }
  [url, tags]
}.reject { |url, tags|
  tags.empty?
}.sort_by { |url, tags|
  url
}.each { |url, tags|
  outfile.puts([url, tags.join(",")].join("\t"))
}
