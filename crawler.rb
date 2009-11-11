#! ruby -Ku

require "cgi"
require "open-uri"
require "uri"
require "net/http"
require "rubygems"
require "json"
require "pp"

HOST = "v3.latest.ironnews-helper2.appspot.com"
#HOST = "localhost:8080"

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

def get_summary(url)
  url  = "http://#{HOST}/hatena-bookmark/get-summary?url1=" + CGI.escape(url)
  json = open(url) { |io| io.read }
  obj  = JSON.parse(json)
  return obj["1"]
end

def get_keyphrase(text)
  url  = "http://#{HOST}/yahoo-keyphrase/extract"
  data = "text1=" + CGI.escape(text)
  uri  = URI.parse(url)
  res  = Net::HTTP.start(uri.host, uri.port) { |http| http.post(uri.path, data) }
  json = res.body
  obj  = JSON.parse(json)
  return obj["1"]["keyphrase"]
end


table = {}

#"電車", "列車", "新幹線", "JR","私鉄"
["鉄道"].each { |keyword|
  STDERR.puts("search news #{keyword}")
  search_news(keyword).each { |article|
    url   = article["url"]
    title = article["title"]
    table[url] = {"google-news-title" => title}
  }
}

table.keys.each { |url|
  next if url == "http://www.jiji.com/jc/c?g=spo_30&k=2009111100254" # なぜかエラー
  next if url == "http://www.jiji.com/jc/c?g=int_30&k=2009111001116"
  next if url == "http://www.jiji.com/jc/c?g=soc_30&k=2009102901089"
  STDERR.puts("get title #{url}")
  info = get_title(url)
  title = info["title"]
  table[url]["hatena-bookmark-title"] = title
}

table.keys.each { |url|
  STDERR.puts("get summary #{url}")
  info = get_summary(url)
  title   = info["title"]
  summary = info["summary"]
  table[url]["hatena-bookmark-title2"]  = title
  table[url]["hatena-bookmark-summary"] = summary
}

#pp table
#puts "-" * 100

table.keys.each { |url|
  summary = table[url]["hatena-bookmark-summary"]
  next if summary.nil?
  STDERR.puts("extract keyphrase #{url}")
  keyphrase = get_keyphrase(summary)
  table[url]["yahoo-keyphrase"] = keyphrase
}

pp table
