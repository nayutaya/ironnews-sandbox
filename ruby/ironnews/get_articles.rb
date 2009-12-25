#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "json"
gem "nayutaya-wsse"
require "wsse"

def read_credential
  return File.open("ironnews.id") { |file| [file.gets.chomp, file.gets.chomp] }
end

def create_wsse
  username, password = read_credential
  return Wsse::UsernameToken.build(username, password).format
end

def get_user_tagged_articles(tag, page = 1, per_page = 10)
  url = "http://ironnews.nayutaya.jp/api/get_user_tagged_articles?tag=#{CGI.escape(tag)}&page=#{page}&per_page=#{per_page}"
  return open(url, {"X-WSSE" => create_wsse}) { |io| JSON.parse(io.read) }
end

def get_all_user_tagged_articles(tag)
  articles = []

  page = 1
  loop {
    result = get_user_tagged_articles(tag, page, 100)
    articles += result["result"]["articles"]

    break if result["result"]["total_pages"] <= page
    page += 1
  }
  return articles
end

articles = get_all_user_tagged_articles("鉄道")
File.open("rail.txt", "wb") { |file|
  articles.each { |article|
    file.puts([article["url"], article["title"].gsub(/[\r\n]/, "")].join("\t"))
  }
}

articles = get_all_user_tagged_articles("非鉄")
File.open("rest.txt", "wb") { |file|
  articles.each { |article|
    file.puts([article["url"], article["title"].gsub(/[\r\n]/, "")].join("\t"))
  }
}
