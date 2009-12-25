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
  url = "http://ironnews.nayutaya.jp/api/get_user_tagged_articles?tag=#{CGI.escape(tag)}"
  return open(url, {"X-WSSE" => create_wsse}) { |io| JSON.parse(io.read) }
end


result = get_user_tagged_articles("鉄道", 1, 100)
