#! ruby -Ku

# dump.xmlを読み込み、「非鉄」タグが設定されているブックマークをはてなブックマークから削除する

require "net/http"
require "rubygems"
require "nokogiri"
require "wsse"

Net::HTTP.version_1_2

create_wsse = proc {
  username, password = File.open("hatena.id") { |file| [file.gets.chomp, file.gets.chomp] }
  Wsse::UsernameToken.build(username, password).format
}

doc = File.open("dump.xml", "rb") { |file| Nokogiri(file) }

items = doc.xpath("//entry").map { |item|
  id    = item.xpath("id").text[/-(\d+)$/, 1]
  url   = item.xpath("link[@rel='related']").attribute("href").text
  tags  = item.xpath("subject").map { |tag| tag.text }
  [id, url, tags]
}.select { |id, url, tags|
  tags.include?("非鉄")
}

Net::HTTP.start("b.hatena.ne.jp") { |http|
  items.each { |id, url, tags|
    p [id, url, tags]
    p http.delete("/atom/edit/#{id}", {"x-wsse" => create_wsse[]})
    sleep(0.3)
  }
}
