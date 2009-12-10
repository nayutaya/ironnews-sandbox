#! ruby -Ku

require "rubygems"
require "nokogiri"

doc = File.open("dump.xml", "rb") { |file| Nokogiri(file) }

items = doc.xpath("//entry").map { |item|
  title = item.xpath("title").text
  url   = item.xpath("link[@rel='related']").attribute("href").text
  url3  = url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  tags  = item.xpath("subject").map { |tag| tag.text }
  [url3, title, tags]
}

rail    = File.open("dump_rail.txt", "wb")
rest    = File.open("dump_rest.txt", "wb")
unknown = File.open("dump_unknown.txt", "wb")

items.sort_by { |url, title, tags|
  url
}.each { |url, title, tags|
  file =
    case
    when tags.include?("鉄道") then rail
    when tags.include?("非鉄") then rest
    else unknown
    end
  file.printf("%s\t%s\t%s\n", url, title, tags.join(","))
}
