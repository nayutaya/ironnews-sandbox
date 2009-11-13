#! ruby -Ku

require "open-uri"
require "rubygems"
require "nokogiri"

def create_url(username)
  return "http://b.hatena.ne.jp/#{username}/"
end

def fetch_user_entries_page(username)
  url = create_url(username)
  src = open(url) { |io| io.read }
  return src
end

def user_entries(username)
  src = fetch_user_entries_page(username)
  File.open("out.html", "wb") { |file| file.write(src) }
  return src
end

src = File.open("out.html", "rb") { |file| file.read }

doc = Nokogiri(src)

entries = doc.css("ul#bookmarked_user")
entries.xpath("li").each { |entry|
  headline = entry.xpath("h3[@class='entry']/a[1]")
  p title = headline.text.strip
  p url   = headline.attribute("href").text.strip
}
