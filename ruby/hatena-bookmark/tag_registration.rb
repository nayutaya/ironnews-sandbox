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

list = STDIN.map { |line|
  url, tags = line.chomp.split(/\t/)
  [url, tags.split(/,/)]
}

username, password = File.open("ironnews.id") { |file| [file.gets.chomp, file.gets.chomp] }

create_wsse = proc {
  Wsse::UsernameToken.build(username, password).format
}

list.each { |url, tags|
  puts(url)

  next if BookmarkUtility.reject?(url)
  canonical_url = BookmarkUtility.get_canonical_url(url)

  add_url = "http://ironnews.nayutaya.jp/api/add_article?url1=" + CGI.escape(canonical_url)
  count = 0
  begin
    result = open(add_url, {"X-WSSE" => create_wsse[]}) { |io| JSON.parse(io.read) }
  rescue OpenURI::HTTPError
    if count < 5
      count += 1
      sleep(1)
      puts("retry#{count}")
      retry
    else
      raise
    end
  end

  article_id = result["result"]["1"]["article_id"]

  tags.each { |tag|
    puts(NKF.nkf("-s", tag))
    tag_url = "http://ironnews.nayutaya.jp/api/add_tags?article_id=#{article_id}&tag1=#{CGI.escape(tag)}"
    result2 = open(tag_url, {"X-WSSE" => create_wsse[]}) { |io| JSON.parse(io.read) }
  }

  sleep(0.2)
}
