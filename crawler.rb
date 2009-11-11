#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "json"
require "pp"

HOST = "v3.latest.ironnews-helper2.appspot.com"

def search_news(keyword, num = 10)
  url  = "http://#{HOST}/google-news/search?keyword=" + CGI.escape(keyword) + "&=num#{num}"
  json = open(url) { |io| io.read }
  obj  = JSON.parse(json)
  return obj
end

def get_title(url)
  url  = "http://#{HOST}/hatena-bookmark/get-title?url1=" + CGI.escape(url)
  json = open(url) { |io| io.read }
  obj  = JSON.parse(json)
  return obj["1"]
end

#articles = 

table = {}

search_news("鉄道").each { |article|
  url   = article["url"]
  title = article["title"]
  table[url] = {"google-news-title" => title}
}

table.keys.each { |url|
  STDERR.puts("get title #{url}")
  info = get_title(url)
  title = info["title"]
  table[url]["hatena-bookmark-title"] = title
}

pp table
