#! ruby -Ku

require "cgi"
require "open-uri"
require "nkf"
require "rubygems"
require "json"
gem "nayutaya-bookmark-utility"
require "bookmark_utility"
gem "nayutaya-wsse"
require "wsse"

list = [
  ["http://373news.com/modules/pickup/index.php?storyid=20485", %w[鉄道 社会]],
  #["http://4510plan.jp/360/newscolumn/12119/", %w[非鉄]],
]

username, password = File.open("ironnews.id") { |file| [file.gets.chomp, file.gets.chomp] }

create_wsse = proc {
  Wsse::UsernameToken.build(username, password).format
}

list.each { |url, tags|
  puts(url)

  next if BookmarkUtility.reject?(url)
  canonical_url = BookmarkUtility.get_canonical_url(url)

  add_url = "http://ironnews.nayutaya.jp/api/add_article?url1=" + CGI.escape(canonical_url)
  result  = open(add_url, {"X-WSSE" => create_wsse[]}) { |io| JSON.parse(io.read) }
  p article_id = result["result"]["1"]["article_id"]

  tags.each { |tag|
    puts(NKF.nkf("-s", tag))
    tag_url = "http://ironnews.nayutaya.jp/api/add_tags?article_id=#{article_id}&tag1=#{CGI.escape(tag)}"
    result2 = open(tag_url, {"X-WSSE" => create_wsse[]}) { |io| JSON.parse(io.read) }
    p result2
  }
}
