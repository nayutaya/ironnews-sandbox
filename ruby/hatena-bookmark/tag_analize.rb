#! ruby -Ku

require "rubygems"
require "nokogiri"

src = File.open("dump.xml", "rb") { |file| file.read }
doc = Nokogiri(src)

doc.xpath("//entry").each { |item|
  title = item.xpath("title").text
  url   = item.xpath("link[@rel='related']").attribute("href").text
  tags  = item.xpath("subject").map { |tag| tag.text }
  p [title, url, tags]
}
